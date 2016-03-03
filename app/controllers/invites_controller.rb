class InvitesController < ApplicationController

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_user.id
    if @invite.save

      #if the user already exists
      if @invite.recipient != nil
        deliver_email(InviteMailer.existing_user_invite(@invite))
        after_invite_existing_user
      else
        deliver_email(InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)))
        after_invite_new_user
      end
    else
      # oh no, creating an new invitation failed
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:organizable_id, :organizable_type, :email)
  end

  def after_invite_existing_user
    # Add the user to the organization
    @invite.organizable.add_invited_user(@invite.recipient)
  end

  def after_invite_new_user
    # nothing to do in default case, user is added to resource when they join via your registration system
  end

  def deliver_email(mail)
    if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('4.2.0')
      mail.deliver_later
    else
      mail.deliver
    end
  end

end
