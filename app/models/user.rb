class User < ActiveRecord::Base
  validates :firstname, :lastname, :email, presence: true
end
