class User < ActiveRecord::Base
  extend Invitation::User

  has_many :memberships
  has_many :companies, through: :memberships
end
