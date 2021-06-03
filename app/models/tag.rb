class Tag < ApplicationRecord
    has_many :user_flow_tags
    has_many :user_flows, through: :user_flow_tags
end
