require 'spec_helper'
require 'invitation/configuration'

describe Invitation::Invitable do
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

  describe '#organization_name' do
    context 'organization_named_by is set' do
      it 'has an organization name' do
        company = create(:company)
        expect(company.invitable_name).to be company.name
      end
    end

    context 'organization_named_by is not set' do
      it 'has an organization name' do
        project = create(:project)
        expect(project.invitable_name).to eq "a #{project.class.name.humanize}"
      end
    end
  end

end

