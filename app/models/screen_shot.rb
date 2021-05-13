class ScreenShot < ApplicationRecord
  belongs_to :user_flow
  belongs_to :tag #, optional: true
  has_many :screen_shot_tags
  has_many :tags, through: :screen_shot_tags
end
