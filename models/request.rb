class Request < ActiveRecord::Base
  validates :value, presence: true, uniqueness: true

  belongs_to :url
end