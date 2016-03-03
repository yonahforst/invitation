require 'spec_helper'

describe 'creating invitable users' do
  it 'gets a user' do
    user = create(:user)
    company = create(:company)
    user.companies << company

    puts user.inspect
    puts "user.companies: #{user.companies.first.inspect}"
    puts "company.users: #{company.users.first.inspect}"
    puts "company.invite_users: #{company.invites_users.first.inspect}"
  end
end

