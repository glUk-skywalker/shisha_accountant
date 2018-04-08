class Shisha < ApplicationRecord
  has_many :user_shishas, dependent: :destroy
  has_many :users, through: :user_shishas
  scope :current, -> { where(current: true) }
  scope :joinable, -> { current.joins(:users).group('shishas.id').having('count(users.id) < ?', Setting.max_shisha_slots) }

  def stop!
    if current
      pay_off!
      update_attributes(current: false)
    end
  end

  def has_slots?
    users.length < Setting.max_shisha_slots
  end

  private

  def pay_off!
    v = price.to_f / users.length
    users.each { |u|
      u.update_attributes(money: u.money - v)
    }
  end
end
