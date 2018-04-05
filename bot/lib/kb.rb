def kb
  keyset = []
  Shisha.current.each do |s|
    keyset << [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "Join #{ s.id }", callback_data: "join:#{ s.id }"),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: "Stop #{ s.id }", callback_data: "stop:#{ s.id }")
    ]
  end

  if Shisha.current.length < Setting.max_shisha_count
    keyset << Telegram::Bot::Types::InlineKeyboardButton.new(text: "Set up new!", callback_data: 'create')
  end

  keyset << Telegram::Bot::Types::InlineKeyboardButton.new(text: '↻', callback_data: '↻')
end
