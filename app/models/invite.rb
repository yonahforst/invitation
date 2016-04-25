# An invitation, tracks the sender and recipient, and what the recipient is invited to.
# Generates a unique token for each invitation. The token is used in the invite url
# to (more) securely identify the invite when a new user clicks to register.
#
class Invite < ActiveRecord::Base
  belongs_to :invitable, polymorphic: true
  belongs_to :sender, class_name: Invitation.configuration.user_model_class_name
  belongs_to :recipient, class_name: Invitation.configuration.user_model_class_name

  before_create :generate_token
  before_save :check_recipient_existence

  validates :email, presence: true
  validates :invitable, presence: true
  validates :sender, presence: true

  def existing_user?
    recipient != nil
  end

  def generate_token
    self.token = SecureRandom.hex(20).encode('UTF-8')
  end

  def check_recipient_existence
    recipient = Invitation.configuration.user_model.find_by_email(email)
    self.recipient_id = recipient.id if recipient
  end
end
