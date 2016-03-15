require 'spec_helper'

describe InviteMailer do

  describe '#existing_user_invite' do
    let(:invite) { create(:invite, :recipient_is_existing_user) }
    let(:mail)   { InviteMailer.existing_user(invite) }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Invitation instructions'
    end

    it 'renders the recipient email' do
      expect(mail.to).to eq([invite.recipient.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([Invitation.configuration.mailer_sender])
    end

    it 'renders the mail body invitation' do
      expect(mail.body).to match /Someone has invited you to/
    end
  end


  describe '#new_user_invite' do
    before do
      allow(Invitation.configuration).to receive(:user_registration_url).and_return(lambda do |params|
        'http://example.org/user_reg_link'
      end)
    end
    let(:invite) { create(:invite, :recipient_is_new_user) }
    let(:mail)   { InviteMailer.new_user(invite) }

    it 'renders the subject' do
      expect(mail.subject).to eq 'Invitation instructions'
    end

    it 'renders the recipient email' do
      expect(mail.to).to eq([invite.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([Invitation.configuration.mailer_sender])
    end

    it 'renders the mail body invitation' do
      expect(mail.body).to match /Someone has invited you to/
    end
  end

end

