# Your user registration controller should include Invitation::UserRegistrationController.
#
module Invitation
  module UserRegistrationController
    extend ActiveSupport::Concern


    # Copy params[:invite_token] to @invite_token. Your user registration form needs
    # to include :invite_token, this method is the controller half of the glue.
    #
    # Use this in your user registration controller in a before_action for the new action.
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
    def check_and_process_invite(new_user = nil)
      if new_user.nil? && defined?(@user)
        new_user = @user
      end

      token = params[:invite_token]
      if token != nil && new_user != nil
        new_user.claim_invite token
      end
    end

  end
end

