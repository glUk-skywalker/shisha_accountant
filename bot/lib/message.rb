class Message
  def initialize(user, text = '', kbd = nil)
    @params = {
      chat_id: user.id,
      text: text,
      reply_markup: kbd ? markup(kbd) : nil
    }
    @token = Rails.application.secrets.bot_token
  end

  def send!
    with_bot do |bot|
      bot.api.send_message(@params)
    end
  end

  def update!(message_id)
    with_bot do |bot|
      bot.api.edit_message_text(@params.merge(message_id: message_id))
    end
  end

  private

  def markup(kbd)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kbd)
  end

  def with_bot
    Telegram::Bot::Client.run(@token) do |bot|
      yield(bot)
    end
  end
end
