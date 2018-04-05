class User < ApplicationRecord
  has_many :user_shishas, foreign_key: :user_id
  has_many :shishas, through: :user_shishas

  def create_shisha
    s = Shisha.create(price: Setting.default_price)
    s.user_shishas.create(user_id: id, shisha_id: s.id)
  end
end
