class Company < ActiveRecord::Base
  invitable named_by: :name

  has_many :memberships
  has_many :users, through: :memberships

end
