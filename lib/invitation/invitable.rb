#
# Any model you wish to invite users to join should extend this concern. This is typically an
# organization or resource with limited membership like an "account" or "project".
#
# Your code is responsible for managing associations between your Invitable and your user model.
#
# For example, to make the model class Account an organization that can receive an invitation
#
#     class Account < ActiveRecord::Base
#       include Invitation::Organization
#       organization_named_by :name
#
#       has_many :account_memberships
#       has_many :users, through: :account_memberships
#     end
#
#
module Invitation
  module Invitable
    extend ActiveSupport::Concern

    included do
      has_many :invites, as: :invitable
      class_attribute :_invitable_named_by
    end


    module ClassMethods

      # Identify the method that the organization will be identified by in invitation emails.
      def invitable_named_by(named_by)
        self._invitable_named_by = named_by
      end

    end


    # Add the invited user to the organization. Called by InvitesController.
    def add_invited_user(user)
      method = Invitation.configuration.user_model.name.underscore.pluralize
      self.send(method).push(user)
    end


    # Get the name of the organization for use in invitations.
    def invitable_name
      if _invitable_named_by
        self.send(_invitable_named_by)
      else
        logger.info "WARNING Invitation: invitable_named_by for #{self.class.name} is not set!"
        "a #{self.class.name.humanize}"
      end
    end

  end
end

