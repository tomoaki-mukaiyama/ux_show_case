class UserFlow < ApplicationRecord
  belongs_to :product
  belongs_to :platform
end
