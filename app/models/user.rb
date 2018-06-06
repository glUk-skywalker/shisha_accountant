class User < ApplicationRecord
  has_many :user_shishas, foreign_key: :user_id
  has_many :shishas, through: :user_shishas
  has_one :login_token
  has_many :events

  default_scope { where(allowed: true) }
  scope :super_admins, -> { where(super_admin: true) }
  scope :smoking, -> { joins(:shishas).where('current=1').distinct('user.id') }
  scope :ready, -> { all - smoking }
  scope :notified, -> { where(notify: true) }
  scope :debtors, -> { where('money < 0') }
  scope :exclude, ->(*users) { where.not(id: users.map(&:id)) }

  after_create :request_accept_or_promote

  def join_shisha(shisha)
    shisha.user_shishas.create(user_id: id, shisha_id: shisha.id)
  end

  def current_shisha
    shishas.current.first
  end

  def photo_url
    url = read_attribute(:photo_url)
    url ? url : 'dummy-ava.png'
  end

  def update_login_token
    t = login_token
    if t
      t.update_attributes({})
    else
      t = create_login_token
    end
    t
  end

  def action
    @action_controller ||= UserActionController.new(self)
  end

  def draw
    @decorator ||= UserDecorator.new(self)
  end

  def add_money(amount)
    ActiveRecord::Base.transaction do
      self.money += amount
      events.create(change: amount, current: money)
      save
    end
    return unless notify?
    text = "You were credited for *#{amount}* RUR.\nCurrent: *#{money}* RUR"
    message.text = text
    message.send!
  end

  def message
    @message ||= Message.for self
  end

  def self.remind_debtors!
    debtors.each do |debtor|
      title = '*Reminder!*'
      text = "Your account is in debt (*#{debtor.money}* RUR). Please, pay off."
      debtor.message.text = title + "\n" + text
      debtor.message.send!
    end
  end

  private

  def should_be_promoted?
    Rails.application.secrets.super_admin_ids.to_a.include? id
  end

  def request_accept_or_promote
    if should_be_promoted?
      update_attributes(allowed: true, super_admin: true)
    else
      request_accept
    end
  end

  def request_accept
    User.super_admins.each do |admin|
      Message.for(admin).accept_user(self).send!
    end
  end
end
