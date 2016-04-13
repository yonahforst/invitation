class Invitation::InvitesController < ApplicationController
  def new
    @invite = invite_from_params
    render template: 'invites/new'
  end

  def create
    @invite = invite_from_params
    @invite.sender_id = current_user.id
    logger.debug '@invite: ' + @invite.inspect
    if @invite.save
      #if the user already exists
      if @invite.recipient != nil
        deliver_email(InviteMailer.existing_user(@invite))
        after_invite_existing_user
      else
        deliver_email(InviteMailer.new_user(@invite))
        after_invite_new_user
      end
      flash[:notice] = t('invitation.flash.invite_issued', email: @invite.email)
    else
      flash[:error] = t('invitation.flash.invite_error')
    end
    respond_to do |format|
      format.html { redirect_to url_after_invite }
      format.json { render json: @invite.as_json(except: :token) }
    end
  end


  private


  # Override this if you want to do something more complicated for existing users.
  def after_invite_existing_user
    # Add the user to the organization
    @invite.invitable.add_invited_user(@invite.recipient)
  end

  # Override if you want to do something more complicated for new users. By default we do nothing.
  def after_invite_new_user
  end

  #
  def url_after_invite
    @invite.invitable
  end

  # Build new Invite from params.
  def invite_from_params
    Invite.new(invite_params)
  end

  def invite_params
    return params.require(:invite).permit(:invitable_id, :invitable_type, :email) if params[:invite]
    Hash.new
  end

  # Use deliver_later from rails 4.2+ if available.
  def deliver_email(mail)
    if mail.respond_to?(:deliver_later)
      mail.deliver_later
    else
      mail.deliver
    end
  end

end
