module Invitation

  class Configuration

    # ActiveRecord model class name that represents your user.
    #
    # Defaults to '::User'.
    attr_accessor :user_model


    # Path for new users to register for your application.
    #
    attr_accessor :registration_path


    attr_accessor :mailer_sender

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
