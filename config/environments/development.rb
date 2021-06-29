Rails.application.configure do
    # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = false
  # Allow images from CDN
  config.action_dispatch.default_headers = {
    'Access-Control-Allow-Origin' => "https://localhost:3000",
    'Access-Control-Request-Method' => "GET",
    'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
    'Access-Control-Allow-Methods' => 'GET',
    'Permissions-Policy' => 'interest-cohort=()'
  }

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application"s code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don"t have to restart the web server when you make code changes.
  config.cache_classes = false

  # Rate limiting
  config.middleware.use(Rack::Attack)

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  config.action_controller.perform_caching = true
  config.cache_store =
    :redis_cache_store, {
      url: Rails.application.secrets[:redis_url],
      error_handler: -> (method:, returning:, exception:) { raise exception },
    }
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=172800",
  }

  require 'connection_pool'
  REDIS = ConnectionPool.new(size: 5) { Redis.new }

  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: "localhost", port: 3000, protocol: 'https' }

  # Mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      port: Rails.application.secrets[:smtp_server_port] || 1025,
      address: Rails.application.secrets[:smtp_server_address] || "127.0.0.1"
  }

  # Use S3 for storage
  config.active_storage.service = :local

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true
  config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
  config.i18n.default_locale = :en

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Resolves docker error "Cannot render console from 172.21.0.1! Allowed networks: 127.0.0.0/127.255.255.255, ::1"
  config.web_console.whitelisted_ips = ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16']

  config.logger = ActiveSupport::Logger.new(config.paths['log'].first, 1, 50.megabytes)
  config.log_level = :debug
  config.after_initialize do
    Bullet.enable = true
    Bullet.rails_logger = true
  end
end
