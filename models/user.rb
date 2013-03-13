class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :password_salt, presence: true
end