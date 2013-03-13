class Url < ActiveRecord::Base
  validate :original,
           :shortened,
            presence: true,
            uniqueness: true

  has_many :users
end