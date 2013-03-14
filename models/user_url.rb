class UserUrl < ActiveRecord::Base
  validates :original, presence: true
  validates :shortened, presence: true

  belongs_to :user
  has_many   :requests
end