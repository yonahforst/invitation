class Project < ActiveRecord::Base
  invitable named: "Project Number"

  has_many :project_memberships
  has_many :users, through: :project_memberships
end
