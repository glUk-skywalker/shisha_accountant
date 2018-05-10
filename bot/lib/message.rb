class Message
  def initialize(user, text = '', kbd = nil)
    @params = {
      chat_id: user.id,
      text: text,
      reply_markup: kbd ? markup(kbd) : nil
    }
  end

  def send!
    bot.api.send_message(@params)
  end

  def update!(message_id)
    bot.api.edit_message_text(@params.merge(message_id: message_id))
  end

  private

  def markup(kbd)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kbd)
  end
end
