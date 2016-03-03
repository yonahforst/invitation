FactoryGirl.define do
  factory :invite do

    trait :recipient_is_existing_user do
      email { create(:user).email }
    end

    trait :recipient_is_new_user do
      email
    end

    after(:build) { |user|
      user.organizable = create(:company)
      user.sender      = create(:user)
    }
  end


end
