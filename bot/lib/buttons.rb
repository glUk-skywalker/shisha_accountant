class Buttons
  STATIC_TYPES = {
    leave:       { text: 'Leave',           callback_data: 'leave' },
    finish:      { text: 'Pay and stop',    callback_data: 'stop' },
    create:      { text: 'Set up new!',     callback_data: 'create' },
    refresh:     { text: '↻',               callback_data: '↻' },
    create_free: { text: 'Add free shisha', callback_data: 'create_free' },
    tools:       { text: 'Tools',           callback_data: 'tools' },
    menu:        { text: 'Main menu',       callback_data: 'menu' }
  }.freeze

  def self.build(params)
    Telegram::Bot::Types::InlineKeyboardButton.new params
  end

  def self.join_shisha(shisha)
    build join_shisha_params(shisha)
  end

  def self.accept_user(user)
    build accept_user_params(user)
  end

  def self.static(type)
    build STATIC_TYPES[type]
  end

  # params generators
  def self.join_shisha_params(shisha)
    {
      text: "Join #{shisha.users.map(&:first_name).to_sentence}",
      callback_data: "join:#{shisha.id}"
    }
  end

  def self.accept_user_params(user)
    {
      text: 'Accept',
      callback_data: "accept_user:#{user.id}"
    }
  end
end
