def kb
  [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '+', callback_data: '+'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: '-', callback_data: '-')
    ],
    Telegram::Bot::Types::InlineKeyboardButton.new(text: '↻', callback_data: '↻'),
  ]
end
