class UserFlowTag < ApplicationRecord
  belongs_to :tag
  belongs_to :user_flow
end
