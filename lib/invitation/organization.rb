module Invitation
  module Organization
    extend ActiveSupport::Concern

    included do
      has_many :invites, as: :organizable

      # you must have built the relationship independently
      has_many :invites_users, class: Invitation.configuration.user_model
    end

  end
end
