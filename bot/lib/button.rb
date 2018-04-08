TYPES = {
  leave: {
    text: "Leave",
    callback_data: "leave"
  },
  finish: {
    text: "Finish smoking",
    callback_data: "stop"
  },
  create: {
    text: "Set up new!",
    callback_data: 'create'
  },
  refresh: {
    text: '↻',
    callback_data: '↻'
  }
}

def button(type)
  Telegram::Bot::Types::InlineKeyboardButton.new TYPES[type]
end
