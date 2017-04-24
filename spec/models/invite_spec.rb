require 'spec_helper'

describe Invite do
  context 'recipient is already a user' do
    subject { create(:invite, :recipient_is_existing_user) }

    it { is_expected.to be_existing_user }

    it 'has a token' do
      expect(subject.token).to_not be_nil
    end

    it 'sets recipient id based on email' do
      expect(subject.recipient_id).to_not be_nil
      expect(subject.recipient.email).to eq(subject.email)
    end

    context 'case mismatch' do
      let!(:user) { create(:user) }
      subject     { create(:invite, email: user.email.upcase) }

      it 'is case-sensitive and does not set recipient by default' do
        expect(subject.recipient_id).to be_nil
      end

      it 'sets recipient if case-sensitivity is disabled' do
        allow(Invitation.configuration).to receive(:case_sensitive_email).and_return(false)
        expect(subject.recipient_id).to_not be_nil
        expect(subject.recipient.email).to eq(user.email)
      end
    end
  end

  context 'recipient is not a user' do
    subject { create(:invite, :recipient_is_new_user) }

    it { is_expected.to_not be_existing_user }

    it 'has a token' do
      expect(subject.token).to_not be_nil
    end

    it 'does not have a recipient yet' do
      expect(subject.recipient_id).to be_nil
    end
  end

  context '#new' do
    let(:account) { create(:account) }

    it 'invalid without email address' do
      invite = Invite.new('invitable_id' => '1', 'invitable_type' => 'Company')
      expect(invite).to_not be_valid
    end

    it 'error message without an email address' do
      invite = Invite.new('invitable_id' => '1', 'invitable_type' => 'Company')
      invite.save
      expect(invite.errors.messages).to_not be_empty
    end
  end
end
