class Shisha < ApplicationRecord
  has_many :user_shishas, dependent: :destroy
  has_many :users, through: :user_shishas
  scope :current, -> { where(current: true) }
  scope :finished, -> { where(current: false) }
  scope :joinable, -> { current.joins(:users).group('shishas.id').having('count(users.id) < ?', Setting.max_shisha_slots) }

  def stop!
    return unless current
    ActiveRecord::Base.transaction do
      pay_off!
      update_attributes(current: false)
    end
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

  def draw
    @decorator ||= ShishaDecorator.new(self)
  end

  def self.stop_old!
    shishas = current.where('created_at < ?', 1.hour.ago)
    shishas.each do |shisha|
      shisha.stop!
      shisha.users.notified.each do |user|
        user.message.text = 'Your shisha has been automatically stopped'
        user.message.send!
      end
    end
  end

  def self.price
    GlobalEvent.spendings_sum.to_f / finished.count * Setting.shisha_price_multiplier
  end

  private

  def pay_off!
    v = price.to_f / users.length
    users.each { |u|
      u.update_attributes(money: u.money - v)
      u.events.create(change: -v, current: u.money, shisha_id: id)
    }
  end
end
