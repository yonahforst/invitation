# email
class Invite < ActiveRecord::Base
  belongs_to :organization, class: Invitation.configuration.organization_model
  belongs_to :sender, class: Invitation.configuration.user_model
  belongs_to :recipient, class: Invitation.configuration.user_model

  before_create :generate_token
  before_save :check_user_existence

  def generate_token
    self.token = SecureRandom.hex(20).encode('UTF-8')
  end

  def check_user_existence
    recipient = Invitation.configuration.user_model.find_by_email(email)
    if recipient
      self.recipient_id = recipient.id
    end
  end
end
