# Invitation requires configuration.#
module Invitation
  # Configure the invitation module. Invoke from a rails initializer.
  #
  # Example:
  #   Invitation.configure do |config|
  #     config.user_registration_path = ->(params) { new_profile_path(param) }
  #   end
  #
  class Configuration
    # Name of the ActiveRecord class that represents users in your application.
    #
    # Example:
    #   Invitation.configure do |config|
    #     config.user_model = 'User'
    #   end
    #
    # DEPRECATED: can be set to the user class (not it's name), e.g. `config.user_model = User`.
    # Support for setting the class directly may be removed in a future update.
    #
    # Defaults to '::User'.
    #
    # @return [ActiveRecord::Base]
    attr_accessor :user_model

    # Url for new users to register for your application. New users are invited to
    # sign up at this url via email. The url should be expressed as a lambda that
    # accepts one argument, a params hash. This hash will contain the invitation token.
    #
    # Defaults to: ->(params) { Rails.application.routes.url_helpers.sign_up_url(params) }
    #
    # Note that the default assumes you have `sign_up_url`.
    #
    # @return [Lambda]
    attr_accessor :user_registration_url

    # Controls the 'from' address for Invitation emails.
    # Set this to a value appropriate to your application.
    #
    # Defaults to reply@example.com.
    #
    # @return [String]
    attr_accessor :mailer_sender

    # Enable or disable Invitation's built-in routes.
    #
    # Defaults to 'true'.
    #
    # If you disable the routes, your application is responsible for all routes.
    #
    # You can deploy a copy of Invitations's routes with `rails generate invitation:routes`,
    # which will also set `config.routes = false`.
    #
    # @return [Boolean]
    attr_accessor :routes

    # Enable or disable email case-sensivity when inviting users.
    # If set to 'false', searching for user existence via email will disregard case.
    #
    # Defaults to 'true'.
    #
    # @return [Boolean]
    attr_accessor :case_sensitive_email

    def initialize
      @user_model = '::User' #if defined?(::User)
      @user_registration_url = ->(params) { Rails.application.routes.url_helpers.sign_up_url(params) }
      @mailer_sender = 'reply@example.com'
      @routes = true
      @case_sensitive_email = true
    end

    # @return [Class]
    def user_model
      if !@user_model.respond_to?(:constantize) && @user_model_class.nil?
        warn <<-EOM.squish
          Invitation's `user_model` configuration setting should now be set to a string
          specifying the user model's class name.
          
          Future versions of Invitation will no longer support setting user_model to a class.
          
          It is recommended that you opt-in now and set your user model to a class name.
          Example:
            Invitation.configure do |config|
              config.user_model = 'User'
            end
        EOM
      end
      @user_model_class ||=
        if @user_model.respond_to?(:constantize)
          @user_model.constantize
        else
          @user_model
        end
    end

    def user_model_class_name
      user_model.name.to_s
    end

    def user_model_instance_var
      '@' + user_model.name.demodulize.underscore
    end

    # @return [Boolean] are Invitation's built-in routes enabled?
    def routes_enabled?
      @routes
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
