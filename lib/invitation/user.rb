# Your user class should include this module.
# Your user class must also be specified at Invitation.configure.user_model.
#
module Invitation
  module User
    extend ActiveSupport::Concern

    included do
      has_many :invitations, class_name: 'Invite', foreign_key: :recipient_id
      has_many :sent_invites, class_name: 'Invite', foreign_key: :sender_id
    end

    module ClassMethods
    end

  end
end
