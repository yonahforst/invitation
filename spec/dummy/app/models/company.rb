class Company < ActiveRecord::Base
  extend Invitation::Organization

  has_many :memberships
  has_many :users, through: :memberships
end
