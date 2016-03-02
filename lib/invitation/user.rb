module Invitation
  module User
    extend ActiveSupport::Concern
    included do
      has_many :invitations, class_name: 'Invite', foreign_key: :recipient_id
      has_many :sent_invites, class_name: 'Invite', foreign_key: :sender_id
    end
  end
end