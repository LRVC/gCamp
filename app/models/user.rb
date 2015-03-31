class User < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :comments

  def full_name
    first_name.capitalize + " " + last_name.capitalize
  end

  def set_user_id_nil_on_comments
    self.comments.update_all(user_id: nil)
  end

  def project_member_of(user)
    user.projects.map(&:users).flatten.include?(self)
  end

  def display_token
    self.tracker_token[0..3] + ('*'*(self.tracker_token.length - 4))
  end
end
