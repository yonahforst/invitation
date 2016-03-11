require 'spec_helper'
require 'invitation/configuration'

describe Invitation::UserRegistration do
  class DummyUserRegistration
    include Invitation::UserRegistration
    def initialize(invite)
      @user = invite.recipient
      @invite = invite
    end
    def params # pretending to be controllerish
      { invite_token: @invite.token }
    end
  end

  it 'check_and_process_invite adds organization to recipient' do
    invite = create(:invite, :recipient_is_existing_user)

    expect(invite.recipient.companies).to_not include invite.organizable
    expect(invite.sender.companies).to include invite.organizable

    reg = DummyUserRegistration.new invite
    reg.check_and_process_invite

    recipient = invite.recipient.reload
    expect(recipient.companies).to include invite.organizable
    expect(invite.organizable.users).to include invite.recipient
  end

end
