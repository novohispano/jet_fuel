class Url < ActiveRecord::Base
  validates :original, presence: true, uniqueness: true
  validates :shortened, presence: true

  has_many :users
  has_many :requests
end