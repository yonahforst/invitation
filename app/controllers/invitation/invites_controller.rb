class Invitation::InvitesController < ApplicationController

  def new
    @invite = invite_from_params
    render template: 'invites/new'
  end

  def create
    @invite = invite_from_params
    @invite.sender_id = current_user.id
    logger.info '@invite: ' + @invite.inspect
    if @invite.save
      #if the user already exists
      if @invite.recipient != nil
        deliver_email(InviteMailer.existing_user_invite(@invite))
        after_invite_existing_user
      else
        deliver_email(InviteMailer.new_user_invite(@invite))
        after_invite_new_user
      end
      flash[:notice] = 'Invitation issued to ' + @invite.email
    else
      flash[:error] = 'Unable to issue invitation'
    end
    redirect_to url_after_invite
  end


  private


  # Override this if you want to do something more complicated for existing users.
  def after_invite_existing_user
    # Add the user to the organization
    @invite.organizable.add_invited_user(@invite.recipient)
  end

  # Override if you want to do something more complicated for new users. By default we do nothing.
  def after_invite_new_user
  end

  # Url sender is redirected to after creating invite.
  def url_after_invite
    Invitation.configuration.url_after_invite
  end

  # User registration url sent to new users.
  def user_registration(params)
    Invitation.configuration.user_registration_url.call(params)
  end

  # Build new Invite from params.
  def invite_from_params
    clean_params = params[:invite] ? invite_params : Hash.new
    Invite.new(clean_params)
  end

  def invite_params
    params.require(:invite).permit(:organizable_id, :organizable_type, :email)
  end

  # Use deliver_later from rails 4.2+ if available.
  def deliver_email(mail)
    if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('4.2.0')
      mail.deliver_later
    else
      mail.deliver
    end
  end

end
