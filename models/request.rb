class Request < ActiveRecord::Base
  validates :value, presence: true, uniqueness: true

  belongs_to :url
  belongs_to :user_url
end