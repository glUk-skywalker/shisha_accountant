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
    user = User.where(id: message.from.id).first
    user ||= User.create(message.from.to_h)

    case message
    when Telegram::Bot::Types::CallbackQuery
      user_message = Message.new(user, '↻ Working...')
      user_message.update!(message.message.message_id)

      if user.allowed
        case message.data
        when 'create'
          user.action.create_shisha
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
          User.find(user_id).update_attributes(allowed: true)
        end
      end

      user_message.text = msg(user)
      user_message.keys = kb(user)
      user_message.update! message.message.message_id
    when Telegram::Bot::Types::Message
      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}")
      when '/menu'
        user.message.text = msg(user)
        user.message.keys = kb(user)
        user.message.send!
      when '/login_link'
        if user.allowed?
          user.message.login_link.send!
        else
          bot.api.send_message(chat_id: message.from.id, text: 'You are not allowed user')
        end
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
