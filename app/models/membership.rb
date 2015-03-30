class Membership < ActiveRecord::Base
  ROLES = ['Member', 'Owner']
  validates :user, presence: true
  validates :role, presence: true, inclusion: ROLES
  validates :user, uniqueness: { scope: :project,
    message: "has already been added to this project" }

  belongs_to :user
  belongs_to :project

end
