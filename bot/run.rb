puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

require 'telegram/bot'
require './bot/lib/kb'

token = Rails.application.secrets.bot_token
v = 0
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = User.where(id: message.from.id).first
    if user
      puts "User exists!"
    else
      puts "New user! Registering"
      User.create(message.from.to_h)
    end

    case message
    when Telegram::Bot::Types::CallbackQuery
      processing_params = {
        chat_id: message.from.id,
        message_id: message.message.message_id,
        text: '↻ Working..',
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      }
      bot.api.edit_message_text(processing_params)

      case message.data
      when 'create'
        Shisha.create(price: Setting.default_price) if Shisha.current.length < Setting.max_shisha_count
      when /join:\d+/
        puts "Joining #{ message.data.split(':').last }..."
      when /stop:\d+/
        shisha_id = message.data.split(':').last
        puts "Stopping #{ message.data.split(':').last }..."
        Shisha.find(shisha_id).update_attributes(current: false)
        puts "Stopped"
      when '↻'
      end

      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: v.to_s, reply_markup: markup)
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}")
      when '/menu'
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: message.from.id, text: v.to_s, reply_markup: markup)
      when '/stop'
        bot.api.send_message(chat_id: message.from.id, text: "Bye, #{message.from.first_name}")
      end
    end
  end
end
