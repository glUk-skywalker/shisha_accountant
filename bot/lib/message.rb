class Message
  attr_accessor :text

  def initialize(user, text = '', keys_set = nil)
    @user = user
    @text = text
    @keys_makup = keys_set ? markup(keys_set) : nil
    @token = Rails.application.secrets.bot_token
  end

  def self.for(user)
    new user
  end

  def accept_user(user)
    @text = user.first_name
    @text << " #{user.last_name}" if user.last_name
    @text << " (@#{user.username})" if user.username
    @text << ' wants to join the party!'
    @text = text
    self.keys = Buttons.accept_user(user)
    self
  end

  def join_offer(owner, shisha)
    @text = "#{owner.first_name} just set up a new shisha!"
    self.keys = Buttons.join_shisha(shisha)
    self
  end

  def keys=(keys_set)
    @keys_makup = keys_set ? markup(keys_set) : nil
  end

  def login_link
    url_params = {
      login_token: {
        token: @user.update_login_token.token
      },
      host: Setting.host
    }
    @text = Rails.application.routes.url_helpers.auth_url(url_params)
    self
  end

  def history
    lines = []
    @user.shishas.each do |shisha|
      price = shisha.price.to_f / shisha.users.length
      line = '*-' + price.to_s + '* '
      line += shisha.created_at.strftime('%A, %d %B %Y, %H:%M')
      line += "\n"
      line += shisha.draw.participants(you: @user)
      line += "\n"
      lines << line
    end
    @text = lines.join("\n")
    self
  end

  def send!
    with_bot do |bot|
      bot.api.send_message(params)
    end
  end

  def update!(message_id)
    with_bot do |bot|
      bot.api.edit_message_text(params.merge(message_id: message_id))
    end
  end

  private

  def params
    {
      chat_id: @user.id,
      text: @text,
      reply_markup: @keys_makup,
      url: @url,
      parse_mode: 'Markdown'
    }
  end

  def markup(kbd)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kbd)
  end

  def with_bot
    Telegram::Bot::Client.run(@token) do |bot|
      yield(bot)
    end
  end
end
