def kb(user)
  keyset = []

  s = user.current_shisha
  if s
    key_row = []
    button_params = {
      text: "Leave",
      callback_data: "leave"
    }
    key_row << Telegram::Bot::Types::InlineKeyboardButton.new(button_params)
    button_params = {
      text: "Finish smoking",
      callback_data: "stop"
    }
    key_row << Telegram::Bot::Types::InlineKeyboardButton.new(button_params)
    keyset << key_row
  else
    Shisha.current.each do |s|
      button_params = {
        text: "Join #{ s.users.map(&:first_name).to_sentence }",
        callback_data: "join:#{ s.id }"
      }
      keyset << [
        Telegram::Bot::Types::InlineKeyboardButton.new(button_params)
      ]
    end

    if Shisha.current.length < Setting.max_shisha_count
      keyset << Telegram::Bot::Types::InlineKeyboardButton.new(text: "Set up new!", callback_data: 'create')
    end
  end

  keyset << Telegram::Bot::Types::InlineKeyboardButton.new(text: '↻', callback_data: '↻')
end
