class UserShisha < ApplicationRecord
  self.primary_key = [:user_id, :shisha_id]
  has_one :user, primary_key: :user_id, foreign_key: :id
  has_one :shisha, primary_key: :shisha_id, foreign_key: :id
end
