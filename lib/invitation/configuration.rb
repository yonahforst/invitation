module Invitation
  class Configuration

    # ActiveRecord model class name that represents your user.
    #
    # Defaults to '::User'.
    attr_accessor :user_model


    # Path for new users to register for your application. New users are invited to
    # sign up at this path.
    #
    # Defaults to '/sign_up'
    attr_accessor :user_registration_path


    # Controls the 'from' address for Invitation emails.
    # Set this to a value appropriate to your application.
    #
    # Defaults to reply@example.com.
    #
    # @return [String]
    attr_accessor :mailer_sender


    # Path that Invitation will redirect users to after an invitation is issued.
    #
    # Defaults to '/'
    #
    # Override the invites_controller method if a more complex url is required.
    # @return [String]
    attr_accessor :url_after_invite


    def initialize
      @user_model = ::User
      @user_registration_path = '/sign_up'
      @mailer_sender = 'reply@example.com'
      @url_after_invite = '/'
    end

    def user_model_class_name
      @user_model.name.to_s
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
