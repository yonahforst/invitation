require 'spec_helper'
require 'support/requests/request_helpers'


feature 'new invite' do
  before do
    @user = create(:user, :with_company)
    @company = @user.companies.first
    sign_in_with @user
  end

  scenario 'contains resource name' do
    visit new_invite_path(invite: { invitable_id: @company.id, invitable_type: @company.class.name })
    expect(page).to have_content("Issue an invitation to join #{@company.invitable_name}")
  end

  scenario 'contains email address field' do
    visit new_invite_path(invite: { invitable_id: @company.id, invitable_type: @company.class.name })
    expect(page).to have_field('invite_email')
  end

  scenario 'invite a new user' do
    email = 'testuser@test.com'
    visit new_invite_path(invite: { invitable_id: @company.id, invitable_type: @company.class.name })
    fill_in 'Email', with: email
    click_button 'Send'
  end

end
