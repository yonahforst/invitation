require 'spec_helper'


describe Invitation::InvitesController do
  describe 'get to #new' do
    before do
      org = current_user.companies.first
      get :new, invite: {invitable_id: org.id, invitable_type: org.class.name}
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
        expect(response.response_code).to be 302
        expect(response).to redirect_to(company_url org)
      end

      it 'sends email' do
        expect(mail).to receive(:deliver)
        subject
      end

      it 'creates invitation' do
        subject
        expect(assigns(:invite)).to_not be_nil
        expect(assigns(:invite).invitable).to eq(org)
        expect(assigns(:invite).sender).to eq(current_user)
        expect(assigns(:invite).email).to eq(email)
      end

      it 'flashes notice' do
        subject
        expect(flash[:notice]).to be_present
      end

      context 'json' do
        subject { post :create, invite: { invitable_id: org.id, invitable_type: org.class.name, email: email }, format: :json }
        it 'responds with success' do
          subject
          expect(response.response_code).to be 200
        end

        it 'responds with json' do
          subject
          parsed = JSON.parse(response.body)
          expect(parsed['email']).to eq email
          expect(parsed['recipient_id']).to be nil
          expect(parsed['sender_id']).to eq current_user.id
          expect(parsed['invitable_id']).to eq org.id
          expect(parsed['invitable_type']).to eq org.class.name
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
        subject
        expect(assigns(:invite)).to_not be_nil
        expect(assigns(:invite).invitable).to eq(org)
        expect(assigns(:invite).sender).to eq(current_user)
        expect(assigns(:invite).recipient).to eq(recipient)
        expect(assigns(:invite).email).to eq(recipient.email)
      end

      it 'flashes notice' do
        subject
        expect(flash[:notice]).to be_present
      end
    end
  end

end
