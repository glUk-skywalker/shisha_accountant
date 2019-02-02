begin
  Process.kill(0, File.read('tmp/pids/bot.pid').to_i)
  exit
rescue
  'Something wrong! Starting...'
end

File.open('tmp/pids/bot.pid', 'w') { |file|
  file.puts Process.pid
}

puts 'Loading Rails env...'
require File.expand_path('../../config/environment', __FILE__)
puts 'Loaded!'

puts 'Connectiong to the db...'
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts 'Connected!'

token = Rails.application.secrets.bot_token

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = User.unscoped.where(id: message.from.id).first
    user ||= User.create(message.from.to_h)

    case message
    when Telegram::Bot::Types::CallbackQuery
      user.message.text = '↻ Working..'
      user.message.update!(message.message.message_id)

      unless user.allowed?
        user.message.text = USER_NOT_ALLOWED_MESSAGE_TEXT
        user.message.update!(message.message.message_id)
        next
      end

      case message.data
      when 'create'
        user.action.create_shisha
      when 'create_free'
        user.action.create_free_shisha
      when /join:\d+/
        shisha_id = message.data.split(':').last
        s = Shisha.where(id: shisha_id).first
        user.action.join_shisha(s)
      when 'leave'
        user.action.leave_shisha
      when 'stop'
        user.action.stop_shisha
      when /accept_user:\d+/
        user_id = message.data.split(':').last
        accepted_user = User.find(user_id)
        accepted_user.update_attributes(allowed: true)
        accepted_user.message.text = 'You have been accepted for using this bot!'
        accepted_user.message.send!
      when 'tools'
        user.message.tools.update! message.message.message_id
        next
      end

      user.message.menu.keys = kb(user)
      user.message.update! message.message.message_id
    when Telegram::Bot::Types::Message
      unless user.allowed?
        user.message.text = USER_NOT_ALLOWED_MESSAGE_TEXT
        user.message.send!
        next
      end

      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}")
      when '/new'
        unless user.allowed?
          user.message.text = USER_NOT_ALLOWED_MESSAGE_TEXT
          user.message.send!
          next
        end
        user.action.create_shisha
        user.message.menu.keys = kb(user)
        user.message.send!
      when '/menu'
        user.message.menu.keys = kb(user)
        user.message.send!
      when '/login_link'
        user.message.login_link.send!
      when '/history'
        user.message.history.send!
      when '/notifications_on'
        user.action.set_notify(true)
      when '/notifications_off'
        user.action.set_notify(false)
      when '/stop'
        bot.api.send_message(chat_id: message.from.id, text: "Bye, #{message.from.first_name}")
      end
    end
  end
end
