class User < ApplicationRecord
  has_many :user_shishas, foreign_key: :user_id
  has_many :shishas, through: :user_shishas

  after_create :request_accept_or_promote

  def create_shisha
    s = Shisha.create(price: Setting.default_price)
    s.user_shishas.create(user_id: id, shisha_id: s.id)
  end

  def current_shisha
    shishas.current.first
  end

  private

  def should_be_promoted?
    Rails.application.secrets.super_admin_ids.include? id
  end

  def request_accept_or_promote
    if should_be_promoted?
      update_attributes(allowed: true, super_admin: true)
    else
      request_accept
    end
  end

  def request_accept
    require 'telegram/bot'

    button_params = {
      text: "Accept",
      callback_data: "accept_user:#{id}"
    }
    button = Telegram::Bot::Types::InlineKeyboardButton.new(button_params)
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: button)

    text = first_name
    text << " #{last_name}" if last_name
    text << " (@#{username})" if username
    text << " wants to join the party!"

    token = Rails.application.secrets.bot_token
    User.where(super_admin: true).each do |admin|
      Telegram::Bot::Client.run(token) do |bot|
        bot.api.send_message(chat_id: admin.id, text: text, reply_markup: markup)
      end
    end
  end
end
