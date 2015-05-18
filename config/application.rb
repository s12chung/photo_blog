require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PhotoBlog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    Jcontroller.ajax = true

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
end
