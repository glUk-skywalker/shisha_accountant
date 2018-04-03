puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

puts "Total rooms count: #{ Room.all.length }"
puts "Creating a new room..."
Room.create(name: "room one")
puts "Total roome count: #{ Room.all.length }"
puts "The last created room is: #{ Room.last.name }"

require 'telegram/bot'

token = Rails.application.secrets.bot_token

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/new_shisha'
      Shisha.create(price: 0)
      msg_lines = []
      msg_lines << "yay! created!"
      msg_lines << "Current shishas count: #{ Shisha.current.length }"
      bot.api.send_message(chat_id: message.chat.id, text: msg_lines.join("\n"))
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
