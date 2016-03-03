class Company < ActiveRecord::Base
  include Invitation::Organization

  has_many :memberships
  has_many :users, through: :memberships
end
