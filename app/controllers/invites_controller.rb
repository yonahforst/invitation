class InvitesController < ApplicationController

  def new
    @invite = invite_from_params
    render template: 'invites/new'
  end

  def create
    @invite = invite_from_params
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
      flash[:notice] = 'Invitation issued to ' + @invite.email
    else
      flash[:error] = 'Unable to issue invitation'
    end
    redirect_to url_after_create
  end

  private

  def invite_from_params
    clean_params = params[:invite] ? invite_params : Hash.new
    Invite.new(clean_params)
  end

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

  def url_after_create
    Invitation.configuration.url_after_invite
  end

end
