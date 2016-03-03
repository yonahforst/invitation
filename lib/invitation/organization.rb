module Invitation
  module Organization
    extend ActiveSupport::Concern

    included do
      has_many :invites, as: :organizable
    end


    # Add user to the organization.
    def add_invited_user user
      method = Invitation.configuration.user_model.name.underscore.pluralize
      self.send(method).push(user)
    end

  end
end
