#
# Your user model must include this concern to send and receive invitations. Your user class must also be
# specified in the invitation configuration `Invitation.configure.user_model`.
#
# Your user model code is responsible for managing associations to any organizations you wish
# to issue invitations to. Your user model will probably also include an authentication model.
#
# For example, to make your user class `User` able to issue invitations to model `Account`:
#
#     class User < ActiveRecord::Base
#       include Invitation::User
#       include Authenticate::User
#
#       has_many :account_memberships
#       has_many :accounts, through: :account_memberships
#     end
#
module Invitation
  module User
    extend ActiveSupport::Concern

    included do
      has_many :invitations, class_name: 'Invite', foreign_key: :recipient_id
      has_many :sent_invites, class_name: 'Invite', foreign_key: :sender_id
    end

    def claim_invite(token)
      invite = Invite.find_by_token(token)
      return unless invite
      organization = invite.organizable
      organization.add_invited_user self
    end

  end
end

