class Button
  TYPES = {
    leave: {
      text: 'Leave',
      callback_data: 'leave'
    },
    finish: {
      text: 'Finish smoking',
      callback_data: 'stop'
    },
    create: {
      text: 'Set up new!',
      callback_data: 'create'
    },
    refresh: {
      text: '↻',
      callback_data: '↻'
    }
  }

  def initialize(params)
    Telegram::Bot::Types::InlineKeyboardButton.new params
  end

  def self.join(shisha)
    button_params = {
      text: "Join #{shisha.users.map(&:first_name).to_sentence}",
      callback_data: "join:#{s.id}"
    }
    new(button_params)
  end

  def self.static(type)
    new(TYPES[type])
  end
end
