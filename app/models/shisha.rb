class Shisha < ApplicationRecord
  has_many :user_shishas, dependent: :destroy
  has_many :users, through: :user_shishas
  scope :current, -> { where(current: true) }

  def stop!
    if current
      pay_off!
      update_attributes(current: false)
    end
  end

  private

  def pay_off!
    v = price.to_f / users.length
    users.each { |u|
      u.update_attributes(money: u.money - v)
    }
  end
end
