class User < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

  has_many :memberships
  has_many :projects, through: :memberships

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end
end
