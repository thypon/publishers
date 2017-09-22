class PublishersController < ApplicationController
  # Number of requests to #create before we present a captcha.
  THROTTLE_THRESHOLD_CREATE = 3
  THROTTLE_THRESHOLD_CREATE_AUTH_TOKEN = 3

  include PublishersHelper

  before_action :authenticate_via_token,
    only: %i(show)
  before_action :authenticate_publisher!,
    except: %i(create
               create_auth_token
               create_done
               new
               new_auth_token)
  before_action :require_unauthenticated_publisher,
    only: %i(create
             create_auth_token
             new
             new_auth_token)
  before_action :require_unverified_publisher,
    only: %i(email_verified
             update_unverified
             verification
             verification_dns_record
             verification_public_file
             verification_failed
             verify)
  before_action :require_verified_publisher,
    only: %i(edit_payment_info
             generate_statement
             home
             verification_done
             update
             uphold_verified)
  before_action :update_publisher_verification_method,
    only: %i(verification_dns_record
             verification_public_file)

  def create
    @publisher = Publisher.new(pending_email: params[:email])

    @should_throttle = should_throttle_create?
    throttle_legit =
      @should_throttle ?
        verify_recaptcha(model: @publisher)
        : true
    if throttle_legit && @publisher.save
      PublisherMailer.verify_email(@publisher).deliver_later!
      PublisherMailer.verify_email_internal(@publisher).deliver_later if PublisherMailer.should_send_internal_emails?
      session[:created_publisher_id] = @publisher.id
      session[:created_publisher_email] = @publisher.pending_email
      redirect_to create_done_publishers_path
    else
      render(:new)
    end
  end

  def create_done
    @publisher_email = session[:created_publisher_email]
  end

  def update
    publisher = current_publisher
    update_params = publisher_update_params

    current_email = publisher.email
    pending_email = publisher.pending_email
    updated_email = update_params[:pending_email]

    if updated_email
      if updated_email == current_email
        update_params[:pending_email] = nil
      elsif updated_email == pending_email
        update_params.delete(:pending_email)
      end
    end

    success = publisher.update(update_params)

    if success && update_params[:pending_email]
      PublisherMailer.notify_email_change(publisher).deliver_later!
      PublisherMailer.confirm_email_change(publisher).deliver_later!
    end

    respond_to do |format|
      format.json {
        if success
          head :no_content
        else
          render(json: { errors: publisher.errors }, status: 400)
        end
      }
    end
  end

  def update_unverified
    @publisher = current_publisher
    success = @publisher.update(publisher_update_unverified_params)
    if success
      redirect_to(publisher_next_step_path(@publisher))
    else
      render(:email_verified)
    end
  end

  # "Magic sign in link" / One time sign-in token via email
  def new_auth_token
    @publisher = Publisher.new
  end

  def create_auth_token
    @publisher = Publisher.new(publisher_create_auth_token_params)
    @should_throttle = should_throttle_create_auth_token?
    throttle_legit =
      @should_throttle ?
        verify_recaptcha(model: @publisher)
        : true
    if !throttle_legit
      render(:new_auth_token)
      return
    end

    emailer = PublisherLoginLinkEmailer.new(
      brave_publisher_id: publisher_create_auth_token_params[:brave_publisher_id],
      email: publisher_create_auth_token_params[:email]
    )
    if emailer.perform
      # Success shown in view #create_auth_token
    else
      flash.now[:alert] = emailer.error
      render(:new_auth_token)
    end
  end

  # User can move forward or will be contacted
  def verification
  end

  # Explains how to verify and has button to check
  def verification_dns_record
  end

  # Verification method
  def verification_public_file
  end

  def email_verified
    @publisher = current_publisher
  end
  # Tied to button on verification_dns_record
  # Call to Eyeshade to perform verification
  # TODO: Rate limit
  # TODO: Support XHR
  def verify
    require "faraday"
    PublisherVerifier.new(
      brave_publisher_id: current_publisher.brave_publisher_id,
      publisher: current_publisher
    ).perform
    current_publisher.reload
    if current_publisher.verified?
      render(:verification_done)
    else
      render(:verification_failed)
    end
  rescue PublisherVerifier::VerificationIdMismatch
    @failure_reason = I18n.t("activerecord.errors.models.publisher.attributes.brave_publisher_id.taken")
    render(:verification_failed)
  rescue Faraday::Error
    @try_again = true
    @failure_reason = I18n.t("shared.api_error")
    render(:verification_failed)
  end

  # Shown after verification is completed to encourage users to submit
  # payment information.
  def verification_done
    @publisher = current_publisher
    @publisher.prepare_uphold_state_token
  end

  def uphold_verified
    @publisher = current_publisher

    # Ensure the uphold_state_token has been set. If not send back to try again
    if @publisher.uphold_state_token.blank?
      redirect_to(publisher_next_step_path(@publisher), alert: I18n.t("publishers.verification_uphold_state_token_does_not_match"))
      return
    end

    # Ensure the state token from Uphold matches the uphold_state_token last sent to uphold. If not send back to try again
    state_token = params[:state]
    if @publisher.uphold_state_token != state_token
      redirect_to(publisher_next_step_path(@publisher), alert: I18n.t("publishers.verification_uphold_state_token_does_not_match"))
      return
    end

    @publisher.receive_uphold_code(params[:code])

    ExchangeUpholdCodeForAccessTokenJob.perform_now(publisher_id: @publisher.id)

    @publisher.reload

    if @publisher.uphold_access_parameters
      render('publishers/finished')
    else
      redirect_to(publisher_next_step_path(@publisher))
    end
  end

  def download_verification_file
    generator = PublisherVerificationFileGenerator.new(publisher: current_publisher)
    content = generator.generate_file_content
    send_data(content, filename: generator.filename)
  end

  # Entrypoint for the authenticated re-login link.
  def show
    redirect_to(publisher_next_step_path(current_publisher))
  end

  # Domain verified. See balance and submit payment info.
  def home
  end

  def log_out
    path = after_sign_out_path_for(current_publisher)
    sign_out(current_publisher)
    redirect_to(path, notice: I18n.t("publishers.logged_out"))
  end

  def generate_statement
    publisher = current_publisher
    statement_period = params[:statement_period]
    report_url = PublisherStatementGenerator.new(publisher: publisher, statement_period: statement_period.to_sym).perform
    respond_to do |format|
      format.json {
        render(json: { reportURL: report_url }, status: 200)
      }
    end
  end

  private

  def authenticate_via_token
    sign_out(current_publisher) if current_publisher
    return if params[:id].blank? || params[:token].blank?
    publisher = Publisher.find(params[:id])
    if PublisherTokenAuthenticator.new(publisher: publisher, token: params[:token], confirm_email: params[:confirm_email]).perform
      if params[:confirm_email].present? && publisher.email == params[:confirm_email]
        flash[:alert] = t("publishers.email_confirmed", email: publisher.email)
      end
      sign_in(:publisher, publisher)
    else
      flash[:alert] = I18n.t("publishers.authentication_token_invalid")
    end
  end

  # Used by #create_auth_token
  # Kinda copied from Publisher #normalize_brave_publisher_id
  def normalize_brave_publisher_id(brave_publisher_id)
    require "faraday"
    PublisherDomainNormalizer.new(domain: brave_publisher_id).perform
  rescue PublisherDomainNormalizer::DomainExclusionError
    "#{I18n.t('activerecord.errors.models.publisher.attributes.brave_publisher_id.exclusion_list_error')} #{Rails.application.secrets[:support_email]}"
  rescue PublisherDomainNormalizer::OfflineNormalizationError => e
    e.message
  rescue Faraday::Error
    I18n.t("activerecord.errors.models.publisher.attributes.brave_publisher_id.api_error_cant_normalize")
  rescue URI::InvalidURIError
    I18n.t("activerecord.errors.models.publisher.attributes.brave_publisher_id.invalid_uri")
  end

  def publisher_update_params
    params.require(:publisher).permit(:pending_email, :name, :show_verification_status)
  end

  def publisher_update_unverified_params
    params.require(:publisher).permit(:brave_publisher_id, :name, :phone, :show_verification_status)
  end

  def publisher_create_auth_token_params
    params.require(:publisher).permit(:email, :brave_publisher_id)
  end

  # If an active session is present require users to explicitly sign out
  def require_unauthenticated_publisher
    return if !current_publisher
    redirect_to(publisher_next_step_path(current_publisher), alert: I18n.t("publishers.already_logged_in"))
  end

  def require_unverified_publisher
    return if !current_publisher.verified?
    redirect_to(publisher_next_step_path(current_publisher), alert: I18n.t("publishers.verification_already_done"))
  end

  def require_verified_publisher
    return if current_publisher.verified?
    redirect_to(publisher_next_step_path(current_publisher), alert: I18n.t("publishers.verification_required"))
  end

  def update_publisher_verification_method
    case params[:action]
    when "verification_dns_record"
      current_publisher.verification_method = "dns_record"
    when "verification_public_file"
      current_publisher.verification_method = "public_file"
    end
    current_publisher.save! if current_publisher.verification_method_changed?
  end

  # Level 1 throttling -- After the first two requests, ask user to
  # submit a captcha. See rack-attack.rb for throttle keys.
  def should_throttle_create?
    Rails.env.production? &&
      request.env["rack.attack.throttle_data"] &&
      request.env["rack.attack.throttle_data"]["registrations/ip"] &&
      request.env["rack.attack.throttle_data"]["registrations/ip"][:count] >= THROTTLE_THRESHOLD_CREATE
  end

  def should_throttle_create_auth_token?
    Rails.env.production? &&
      request.env["rack.attack.throttle_data"] &&
      request.env["rack.attack.throttle_data"]["created-auth-tokens/ip"] &&
      request.env["rack.attack.throttle_data"]["created-auth-tokens/ip"][:count] >= THROTTLE_THRESHOLD_CREATE_AUTH_TOKEN
  end
end
