class ScreenShot < ApplicationRecord
  belongs_to :product
  belongs_to :platform
  has_one :tag
  has_many :screen_shot_tags
  has_many :tags, through: :screen_shot_tags
end
