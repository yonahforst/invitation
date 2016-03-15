class Company < ActiveRecord::Base
  include Invitation::Organization
  organization_named_by :name

  has_many :memberships
  has_many :users, through: :memberships

end
