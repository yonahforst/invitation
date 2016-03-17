require 'spec_helper'
require 'invitation/configuration'

describe Invitation::User do
  context 'invitation claimed by new user' do
    let(:invite) { create(:invite, :recipient_is_new_user) }
    let(:user) { create(:user, email: invite.email) }
    before(:each) {
      user.claim_invite invite.token
    }

    it 'claims invites' do
      expect(user.companies).to include invite.invitable
    end


    it 'tracks invitations' do
      expect(user.invitations).to include invite
    end
  end

end
