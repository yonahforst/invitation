class Project < ActiveRecord::Base
  include Invitation::Invitable

  has_many :project_memberships
  has_many :users, through: :project_memberships
end
