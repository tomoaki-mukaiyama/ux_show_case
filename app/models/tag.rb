class Tag < ApplicationRecord
    has_many :user_flow_tags
    has_many :screen_shot_tags
end
