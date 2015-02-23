class User < ActiveRecord::Base
  validates :firstname, :lastname, presence: true
  validates :email, presence: true, uniqueness: true
end
