class User < ApplicationRecord
  has_many :user_shishas, foreign_key: :user_id
  has_many :shishas, through: :user_shishas
  has_one :login_token

  scope :super_admins, -> { where(super_admin: true) }

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
    self.money += amount
    save
    msg = Message.for self
    msg.text = "You were credited for #{amount} RUR.\nCurrent: #{money} RUR"
    msg.send!
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
    require Rails.root.join('bot', 'requires')
    User.super_admins.each do |admin|
      Message.for(admin).accept_user(self).send!
    end
  end
end
