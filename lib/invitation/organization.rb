module Invitation
  module Organization
    extend ActiveSupport::Concern

    included do
      has_many :invites, as: :organizable
    end

  end
end
