module Invitation

  class Configuration
    # ActiveRecord model class name that represents your user.
    #
    # Defaults to '::User'.
    attr_accessor :user_model


    # ActiveRecord model class name that represents your organization.
    #
    attr_accessor :organization_model
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
