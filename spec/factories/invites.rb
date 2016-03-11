FactoryGirl.define do

  factory :invite do

    trait :recipient_is_existing_user do
      email { create(:user).email }
    end

    trait :recipient_is_new_user do
      email
    end

    after(:build) { |invite|
      invite.sender      = create(:user)
      invite.organizable = create(:company)
      invite.organizable.users << invite.sender
    }
  end

end
