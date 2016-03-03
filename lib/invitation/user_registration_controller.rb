# UserRegistrationController
#
module Invitation
  module UserRegistrationController
    extend ActiveSupport::Concern

    # Check for an invitation token and process the invite. Whatever adding the invitation to the user
    # if needed.
    #
    # Call *after* the new user has been saved.
    #
    # Return true is an invitation is processed, false if no invitation is found.
    def check_and_process_invitation(new_user)
      token = params[:invite_token]

      if token != nil
        organization = Invite.find_by_token(@token).organizable #find the organization attached to the invite
        add_new_user_to_organization(new_user, organization)
        return true
      end

      false
    end


    # Default implementation adds the user to the organization.
    # Override this method to do something more complicated.
    def add_new_user_to_organization(new_user, organization)
      organization.add_invited_user new_user
    end

  end
end
