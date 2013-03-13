class User < ActiveRecord::Base
  validate :email, presence: true, uniqueness: true
  validate :password_hash, presence: true
  validate :password_salt, presence: true
end