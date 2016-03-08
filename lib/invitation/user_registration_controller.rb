# Your user registration controller should include Invitation::UserRegistrationController.
#
module Invitation
  module UserRegistrationController
    extend ActiveSupport::Concern

    # Copy params[:invite_token] to @invite_token. Your user registration form needs
    # to include :invite_token, this method is the controller half of the glue.
    #
    # Use this in your user registration controller in a before_action, e.g.:
    #
    #     before_action :set_token, only: [:new]
    #
    def set_invite_token
      @invite_token = params[:invite_token]
    end


    # Check for an invitation token and process the invite. If an invitation is found, the invite's
    # organization is added to the user.
    #
    # Use this when creating a new user. Invoke manually or from an after_action:
    #
    #    after_action :check_and_process_invitation, only: [:create]
    #
    # Invoke with new_user, or set @user.
    #
    # Return true is an invitation is processed, false if no invitation is found.
    def check_and_process_invitation(new_user = nil)
      if new_user.nil? && defined?(@user)
        new_user = @user
      end

      token = params[:invite_token]
      if token != nil && new_user != nil
        invite = Invite.find_by_token(token)
        organization = invite.organizable #find the organization attached to the invite
        add_new_user_to_organization(new_user, organization)
        return true
      end

      false
    end


    # Default implementation adds the user to the organization.
    # Override this method to do something more complicated.
    def add_new_user_to_organization(new_user, organization)
      if organization != nil && new_user != nil
        organization.add_invited_user new_user
        Rails.logger.debug "added #{new_user.inspect} to #{organization.inspect}"
      end
    end

  end
end
