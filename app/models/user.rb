# User model
class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :name, :password_digest, :password, :password_confirmation

  # Validation (You must add or update record where the minimum length of "password" is 8)
  validates :password, :length => {:minimum => 8}
end
