puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

require 'telegram/bot'

token = Rails.application.secrets.bot_token
v = 0
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      case message.data
      when '+'
        v += 1
      when '-'
        v -= 1
      end
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: '+', callback_data: '+'),
        Telegram::Bot::Types::InlineKeyboardButton.new(text: '-', callback_data: '-')
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: v.to_s, reply_markup: markup)
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when '/show_menu'
        kb = [
          Telegram::Bot::Types::InlineKeyboardButton.new(text: '+', callback_data: '+'),
          Telegram::Bot::Types::InlineKeyboardButton.new(text: '-', callback_data: '-')
        ]
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: v.to_s, reply_markup: markup)
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
      end
    end
  end
end
