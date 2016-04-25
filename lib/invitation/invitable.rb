module Invitation
  #
  # Any model you wish to invite users to join should extend this concern. This is typically an
  # organization or resource with limited membership like an "account" or "project".
  #
  # Your code is responsible for managing associations between your Invitable and your user model.
  #
  # For example, to make the model class Account an organization that can receive an invitation
  #
  #     class Account < ActiveRecord::Base
  #       invitable named_by: :name
  #
  #       has_many :account_memberships
  #       has_many :users, through: :account_memberships
  #     end
  #
  #
  module Invitable
    # All resources or organizations should be invitable.
    #
    # @param [Hash] options - either named_by: <method name> or named: <String>
    def invitable(options = {})
      has_many :invites, as: :invitable
      class_attribute :invitable_options
      self.invitable_options = {}
      case
      when options[:named_by] then invitable_options[:named_by] = options[:named_by]
      when options[:named] then invitable_options[:named] = options[:named]
      else raise 'invitable requires options be set, either :name or :named_by. \
                 e.g.: `invitable named: "string"` or `invitable named_by: :method_name`'
      end
      include Invitation::Invitable::InstanceMethods
    end

    # Instance methods for invitables.
    module InstanceMethods
      #
      # Add the invited user to the organization. Called by InvitesController.
      #
      def add_invited_user(user)
        method = Invitation.configuration.user_model.name.underscore.pluralize
        send(method).push(user)
      end

      #
      # Get the name of the organization for use in invitations.
      #
      def invitable_name
        if invitable_options[:named_by]
          send(invitable_options[:named_by])
        elsif invitable_options[:named]
          invitable_options[:named]
        else
          raise 'Invitation runtime error: invitable does not have name: or named_by: set, should not be possible! ' +
                inspect
        end
      end
    end
  end
end
