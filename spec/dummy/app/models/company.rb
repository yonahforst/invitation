class Company < ActiveRecord::Base
  include Invitation::Invitable
  invitable_named_by :name

  has_many :memberships
  has_many :users, through: :memberships

end
