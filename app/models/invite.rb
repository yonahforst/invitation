# email
class Invite < ActiveRecord::Base
  belongs_to :invitable, polymorphic: true
  belongs_to :sender, class_name: Invitation.configuration.user_model_class_name
  belongs_to :recipient, class_name: Invitation.configuration.user_model_class_name

  before_create :generate_token
  before_save :check_user_existence

  validates :email, presence: true
  validates :invitable, presence: true
  validates :sender, presence: true


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
