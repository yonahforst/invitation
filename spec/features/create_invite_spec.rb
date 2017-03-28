require 'spec_helper'
require 'support/requests/request_helpers'


feature 'create invitation' do
  before do
    @user = create(:user, :with_company)
    @company = @user.companies.first
    sign_in_with @user
  end

  scenario 'sends email' do
    expect { send_invitation }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  scenario 'redirects to invitable#show' do
    send_invitation
    expect(page).to have_current_path(company_path(@company))
    expect(page).to have_content 'company#show'
  end

  scenario 'displays flash issuing invitation' do
    send_invitation
    expect(page).to have_content( I18n.t('invitation.flash.invite_issued', count: 1) )
  end

  def send_invitation
    email = 'testuser@test.com'
    visit new_invite_path(invite: { invitable_id: @company.id, invitable_type: @company.class.name })
    fill_in 'Email', with: email
    click_button 'Send'
  end
end
