# typed: strong
# This is an autogenerated file for Rails' jobs.
# Please rerun bundle exec rake rails_rbi:jobs to regenerate.
class Promo::RegisterChannelForPromoJob
  sig { params(channel_id: T.untyped, attempt_count: T.untyped).returns(Promo::RegisterChannelForPromoJob) }
  def self.perform_later(channel_id:, attempt_count: 0); end

  sig { params(channel_id: T.untyped, attempt_count: T.untyped).returns(Promo::RegisterChannelForPromoJob) }
  def self.perform_now(channel_id:, attempt_count: 0); end

  sig do
    params(
      wait: T.nilable(ActiveSupport::Duration),
      wait_until: T.nilable(T.any(ActiveSupport::TimeWithZone, Date, Time)),
      queue: T.nilable(T.any(String, Symbol)),
      priority: T.nilable(Integer)
    ).returns(T.self_type)
  end
  def self.set(wait: nil, wait_until: nil, queue: nil, priority: nil); end
end
