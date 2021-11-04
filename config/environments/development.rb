# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Disable delivery errors
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to stderr and the Rails logger.
  config.active_support.deprecation = [:stderr, :log]

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'localhost:3000', protocol: 'http' }

  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => "trucanh88879@gmail.com",
    :password             => "nqqkajehnxeteaxf",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
end
