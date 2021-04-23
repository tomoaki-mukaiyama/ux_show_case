class Product < ApplicationRecord
    has_many :user_flow
    has_many :screen_shots
end
