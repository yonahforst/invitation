require 'spec_helper'
require 'invitation/configuration'

describe Invitation::UserRegistration do

  # guts of a User Registration controller
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


  it 'process_invite adds organization to recipient' do
    invite = create(:invite, :recipient_is_existing_user)

    expect(invite.recipient.companies).to_not include invite.invitable
    expect(invite.sender.companies).to include invite.invitable

    reg = DummyUserRegistration.new invite
    reg.process_invite

    recipient = invite.recipient.reload
    expect(recipient.companies).to include invite.invitable
    expect(invite.invitable.users).to include invite.recipient
  end

end
