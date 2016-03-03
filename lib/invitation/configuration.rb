module Invitation
  class Configuration

    # ActiveRecord model class name that represents your user.
    #
    # Defaults to '::User'.
    attr_accessor :user_model


    # Path for new users to register for your application. New users are invited to
    # sign up at this path.
    #
    attr_accessor :user_registration_path


    # Controls the 'from' address for Invitation emails.
    # Set this to a value appropriate to your application.
    #
    # Defaults to reply@example.com.
    #
    # @return [String]
    attr_accessor :mailer_sender


    def initialize
      @user_model = ::User
      @mailer_sender = 'reply@example.com'
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
