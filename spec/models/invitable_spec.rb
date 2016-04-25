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
    company = invite.invitable
    expect(company.invites).to include invite
  end

  describe '#invitable_name' do
    context 'invitable named_by is set' do
      it 'has an organization name' do
        company = create(:company)
        expect(company.invitable_name).to be company.name
      end
    end

    context 'invitable named is set' do
      it 'has an organization name' do
        project = create(:project)
        expect(project.invitable_name).to eq 'Project Number'
      end
    end

    context 'invitable no args' do
      it 'raises exception when invitable does not set named or named_by' do
        class AbstractModel < ActiveRecord::Base; end
        stub_const 'Project', AbstractModel
        Project.class_eval { self.table_name = 'projects' }
        expect { Project.class_eval { invitable } }.to raise_error(/invitable requires options be set/)
      end
    end
  end
end
