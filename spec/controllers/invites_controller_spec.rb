require 'spec_helper'


describe Invitation::InvitesController do
  describe 'get to #new no params' do
    before do
      get :new
    end
    it { is_expected.to respond_with 200 }
    it 'renders form' do
      expect(assigns(:invite))
    end
  end

  describe 'get to #new' do
    before do
      invitable = current_user.companies.first
      get :new, invite: {invitable_id: invitable.id, invitable_type: invitable.class.name}
    end

    it { is_expected.to respond_with 200 }

    it 'creates new invite for senders company' do
      expect(assigns(:invite).invitable).to eq(current_user.companies.first)
    end

    it 'renders form' do
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'post to #create' do
    let(:mail) { double }
    before(:each) do
      allow(mail).to receive(:deliver)
      allow(controller).to receive(:current_user) { current_user }
    end

    context 'invite a new user' do
      let(:email) { 'gug@gug.com' }
      let(:org) { current_user.companies.first }
      before do
        allow(InviteMailer).to receive(:new_user) { mail }
      end
      subject { post :create, invite: { invitable_id: org.id, invitable_type: org.class.name, email: email } }

      it 'redirects' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(company_url org)
      end

      it 'sends email' do
        expect(mail).to receive(:deliver)
        subject
      end

      it 'creates invitation' do
        expect{ subject }.to change{ Invite.count }.by(1)
      end

      it 'flashes notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      context 'json' do
        context 'invite single user' do
          subject { post :create, invite: { invitable_id: org.id, invitable_type: org.class.name, email: email }, format: :json }

          it 'responds with success' do
            subject
            expect(response).to have_http_status(:success)
            expect(response).to have_http_status(:created)
          end

          it 'responds with json' do
            subject
            invite = JSON.parse(response.body)
            expect(invite['email']).to eq email
            expect(invite['recipient_id']).to be nil
            expect(invite['sender_id']).to eq current_user.id
            expect(invite['invitable_id']).to eq org.id
            expect(invite['invitable_type']).to eq org.class.name
          end
        end

        context 'invite two users' do
          let(:email2) { 'gug2@gug.com' }
          subject { post :create, invite: { invitable_id: org.id, invitable_type: org.class.name, emails: [email, email2] }, format: :json }

          it 'responds with success' do
            subject
            expect(response).to have_http_status(:success)
            expect(response).to have_http_status(:created)
          end

          it 'responds with json invites' do
            subject
            invites = JSON.parse(response.body)
            expect(invites.count).to be 2
            expect(invites[0]['email']).to eq email
            expect(invites[1]['email']).to eq email2
            expect(invites[0]['recipient_id']).to be nil
            expect(invites[1]['recipient_id']).to be nil
            expect(invites[0]['sender_id']).to eq current_user.id
            expect(invites[1]['sender_id']).to eq current_user.id
            expect(invites[0]['invitable_id']).to eq org.id
            expect(invites[1]['invitable_id']).to eq org.id
            expect(invites[0]['invitable_type']).to eq org.class.name
            expect(invites[1]['invitable_type']).to eq org.class.name
          end
        end

      end
    end

    context 'invite an existing user' do
      let(:recipient) { create(:user) }
      let(:org) { current_user.companies.first }
      before do
        allow(InviteMailer).to receive(:existing_user) { mail }
      end
      subject { post :create, invite: { invitable_id: org.id, invitable_type: org.class.name, email: recipient.email } }

      it 'redirects' do
        subject
        expect(response.response_code).to be 302
      end

      it 'sends email' do
        expect(mail).to receive(:deliver)
        subject
      end

      it 'creates invitation' do
        expect{ subject }.to change{ Invite.count }.by(1)
      end

      it 'flashes notice' do
        subject
        expect(flash[:notice]).to be_present
      end
    end

    context 'post to #create many users' do
      let(:recipient1) { create(:user) }
      let(:recipient2) { create(:user) }
      let(:org) { current_user.companies.first }
      before do
        allow(InviteMailer).to receive(:existing_user) { mail }
      end
      subject { post :create,
                     invite: { invitable_id: org.id, invitable_type: org.class.name,
                               # emails: [recipient1.email, recipient2.email] },
                               email: recipient1.email },
                     format: :json }
      it 'gug' do
        subject
        # puts response.inspect
      end

    end
  end

end
