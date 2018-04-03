puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

require 'telegram/bot'

token = Rails.application.secrets.bot_token

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/new_shisha'
      if Setting.max_shisha_count > Shisha.current.length
        Shisha.create(price: Setting.default_price)
        msg = "yay! created!"
      else
        msg = "Sorry, maximum amount of shishas reached :("
      end
      bot.api.send_message(chat_id: message.chat.id, text: msg)
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
