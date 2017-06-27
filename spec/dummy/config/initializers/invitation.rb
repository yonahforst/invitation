Invitation.configure do |config|
  config.user_model = 'User'
  config.user_registration_url = ->(params) { 'this_is_a_fake_user_registration_url' }
end
