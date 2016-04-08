# Your user registration controller should include this concern.
#
module Invitation
  module UserRegistration
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


    # Check for an invitation token and process the invite. If an invitation is found, the
    # user claims the invite.
    #
    # Use this only when creating a new user. Invoke manually or from an after_action:
    #
    #     after_action :process_invite, only: [:create]
    #
    # Invoke with new_user, or set an instance variable with the standard 'underscore' name of your user model class.
    # For example, if your user model is UserProfile, this method will check for @user_profile.
    #
    def process_invite_token(new_user = nil)
      if new_user.nil?
        new_user = user_instance_variable
      end

      token = params[:invite_token]
      if token != nil && new_user != nil
        new_user.claim_invite token
      end
    end


    private


    def user_instance_variable
      name = Invitation.configuration.user_model_instance_var
      self.instance_variable_get(name)
    end

  end
end

