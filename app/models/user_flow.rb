class UserFlow < ApplicationRecord
  belongs_to :product
  belongs_to :platform
  has_many :user_flow_tags
  has_many :tags, through: :user_flow_tags
  validates :screenshot_path, presence: true
end
