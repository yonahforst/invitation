require 'invitation/invites_controller'

module Requests
  module RequestHelpers
    #
    # Fake a signed in user by populating current_user.
    #
    def sign_in_with(user)
      allow_any_instance_of(Invitation::InvitesController).to receive(:current_user).and_return(user)
    end

    #
    # Request header to specify json
    #
    def json_headers
      { :headers => { 'ACCEPT' => 'application/json' } }
    end
  end
end

# Hacky monkey patch, do later deliveries right now, so
class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end


RSpec.configure do |config|
  config.include Requests::RequestHelpers, type: :request
  config.include Requests::RequestHelpers, type: :feature
end
