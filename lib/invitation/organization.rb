# Any 'organization' model you wish to invite users to join should extend this concern.
#
# Your code is responsible for managing associations to the user model.
#
# For example, to make the model class Account an organization that can receive an invitation
#
#     class Account < ActiveRecord::Base
#       include Invitation::Organization
#
#       has_many :account_memberships
#       has_many :users, through: :account_memberships
#     end
#
#
module Invitation
  module Organization
    extend ActiveSupport::Concern

    included do
      has_many :invites, as: :organizable
    end


    # Add the invited user to the organization. This is called by InvitesController
    def add_invited_user user
      method = Invitation.configuration.user_model.name.underscore.pluralize
      self.send(method).push(user)
    end

  end
end
