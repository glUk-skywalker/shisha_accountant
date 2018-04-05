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
v = Shisha.current.length
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
        if Shisha.current.length < Setting.max_shisha_count && user.shishas.current.length == 0
          user.create_shisha
        end
      when /join:\d+/
        shisha_id = message.data.split(':').last
        s = Shisha.where(shisha_id).first
        if s
          UserShisha.create(user_id: user.id, shisha_id: s.id)
        end
      when 'leave'
        s = user.current_shisha
        UserShisha.where(user_id: user.id, shisha_id: s.id).first.destroy
        s.destroy unless s.users.any?
      when /stop:\d+/
        shisha_id = message.data.split(':').last
        s = Shisha.where(shisha_id).first
        s.update_attributes(current: false) if s
        puts "Stopped"
      when '↻'
      end

      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb(user))
      bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: Shisha.current.length, reply_markup: markup)
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}")
      when '/menu'
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb(user))
        bot.api.send_message(chat_id: message.from.id, text: v.to_s, reply_markup: markup)
      when '/stop'
        bot.api.send_message(chat_id: message.from.id, text: "Bye, #{message.from.first_name}")
      end
    end
  end
end
