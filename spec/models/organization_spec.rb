require 'spec_helper'
require 'invitation/configuration'

describe Invitation::Organization do

  it 'adds a user' do
    user = create(:user)
    company = create(:company)
    company.add_invited_user user
    expect(company.users).to include(user)
  end

  it 'tracks invites' do
    invite = create(:invite, :recipient_is_existing_user)
    company = invite.organizable
    expect(company.invites).to include invite
  end

end

