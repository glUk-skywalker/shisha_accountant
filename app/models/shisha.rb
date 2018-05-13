class Shisha < ApplicationRecord
  has_many :user_shishas, dependent: :destroy
  has_many :users, through: :user_shishas
  scope :current, -> { where(current: true) }
  scope :finished, -> { where(current: false) }
  scope :joinable, -> { current.joins(:users).group('shishas.id').having('count(users.id) < ?', Setting.max_shisha_slots) }

  def stop!
    return unless current
    pay_off!
    update_attributes(current: false)
  end

  def has_slots?
    users.length < Setting.max_shisha_slots
  end

  def joinable_for?(user)
    current? && has_slots? && !users.include?(user)
  end

  def self.available?
    Shisha.current.length < Setting.max_shisha_count
  end

  private

  def pay_off!
    v = price.to_f / users.length
    users.each { |u|
      u.update_attributes(money: u.money - v)
    }
  end
end
