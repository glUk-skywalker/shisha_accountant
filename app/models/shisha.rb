class Shisha < ApplicationRecord
  has_many :user_shishas, dependent: :destroy
  has_many :users, through: :user_shishas
  default_scope -> { where('free is null') }
  scope :free, -> { unscoped.where('free is not null') }
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

  def self.remind_smokers!
    shishas = current.where('created_at < ?', 1.hour.ago)
    shishas.each do |shisha|
      shisha.users.each do |user|
        text = 'You are smoking for more then an hour already.'
        text << "\nDon\' forget to stop the shisha!"
        user.message.text = text
        user.message.keys = Buttons.static(:finish)
        user.message.send!
      end
    end
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
