puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

require 'telegram/bot'
require './bot/lib/button'
require './bot/lib/kb'
require './bot/lib/msg'
require './bot/lib/helpers'

token = Rails.application.secrets.bot_token

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = User.where(id: message.from.id).first
    user ||= User.create(message.from.to_h)

    case message
    when Telegram::Bot::Types::CallbackQuery
      processing_params = {
        chat_id: message.from.id,
        message_id: message.message.message_id,
        text: '↻ Working...',
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb(user))
      }
      bot.api.edit_message_text(processing_params)

      case message.data
      when 'create'
        if new_shisha_available? && !user.current_shisha
          user.create_shisha
        end
      when /join:\d+/
        shisha_id = message.data.split(':').last
        s = Shisha.where(id: shisha_id).first
        if s && s.current && s.has_slots?
          UserShisha.create(user_id: user.id, shisha_id: s.id)
        end
      when 'leave'
        s = user.current_shisha
        if s
          UserShisha.where(user_id: user.id, shisha_id: s.id).first.destroy
          s.destroy unless s.users.any?
        end
      when 'stop'
        s = user.current_shisha
        s.stop! if s
      when '↻'
      end

      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb(user))
      bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: msg(user), reply_markup: markup)
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}")
      when '/menu'
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb(user))
        bot.api.send_message(chat_id: message.from.id, text: msg(user), reply_markup: markup)
      when '/stop'
        bot.api.send_message(chat_id: message.from.id, text: "Bye, #{message.from.first_name}")
      end
    end
  end
end
