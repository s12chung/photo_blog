PhotoBlog::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log


  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  CarrierWave.configure do |config|
    s3_config = YAML.load_file('./config/s3.yml').symbolize_keys
    config.fog_credentials = { provider: 'AWS' }.merge(s3_config[:credentials])
    config.fog_directory = s3_config[:s3_bucket]
  end

  YAML.load_file('./config/omniauth.yml')[Rails.env].each do |provider, values|
    values.each do |type, value|
      ENV["#{provider}_#{type}".upcase] = value.to_s
    end
  end

  begin
    # check if memcached is running; if it is, use that instead of the default memory cache
    Timeout.timeout(0.5) { TCPSocket.open("localhost", 11211) { } }
    config.cache_store = :dalli_store
    $stderr.puts "Using memcached on localhost:11211"
  rescue StandardError
    config.cache_store = :memory_store
    $stderr.puts "memcached not running, caching to memory"
  end
end