require 'spec_helper'

describe InviteMailer do
  def get_message_part(mail, content_type)
    mail.body.parts.find { |p| p.content_type.match content_type }.body.raw_source
  end

  shared_examples_for 'multipart email' do
    it 'generates a multipart message (plain text and html)' do
      expect(mail.body.parts.length).to eq 2
      expect(mail.body.parts.collect(&:content_type)).to eq ['text/plain; charset=UTF-8', 'text/html; charset=UTF-8']
    end
  end

  shared_examples_for 'multipart email with bodies' do
    context 'multipart email bodies' do
      describe 'text version' do
        let(:part) { get_message_part(mail, /plain/) }
        it 'has invite content' do
          expect(part).to match(/#{invite.sender.email} has invited you to/)
        end
      end

      describe 'html version' do
        let(:part) { get_message_part(mail, /html/) }
        it 'has invite content' do
          expect(part).to match(/#{invite.sender.email} has invited you to/)
        end
      end
    end
  end

  describe '#existing_user_invite' do
    let(:invite) { create(:invite, :recipient_is_existing_user) }
    let(:mail)   { InviteMailer.existing_user(invite) }

    it_behaves_like 'multipart email'
    it_behaves_like 'multipart email with bodies'

    it 'renders the subject' do
      expect(mail.subject).to eq 'Invitation instructions'
    end

    it 'renders the recipient email' do
      expect(mail.to).to eq([invite.recipient.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([Invitation.configuration.mailer_sender])
    end
  end

  describe '#new_user_invite' do
    before do
      allow(Invitation.configuration).to receive(:user_registration_url).and_return(lambda do |_params|
        'http://example.org/user_reg_link'
      end)
    end
    let(:invite) { create(:invite, :recipient_is_new_user) }
    let(:mail)   { InviteMailer.new_user(invite) }

    it_behaves_like 'multipart email'
    it_behaves_like 'multipart email with bodies'

    it 'renders the subject' do
      expect(mail.subject).to eq 'Invitation instructions'
    end

    it 'renders the recipient email' do
      expect(mail.to).to eq([invite.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([Invitation.configuration.mailer_sender])
    end
  end
end
