class User < ActiveRecord::Base
  include Invitation::User

  has_many :memberships
  has_many :companies, through: :memberships

  has_many :project_memberships
  has_many :projects, through: :project_memberships
end
