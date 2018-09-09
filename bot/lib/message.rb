class Message
  attr_accessor :text

  def initialize(user, text = '', keys_set = nil)
    @user = user
    @text = text
    @parse_mode = 'Markdown'
    @keys_makup = keys_set ? markup(keys_set) : nil
    @token = Rails.application.secrets.bot_token
  end

  def self.for(user)
    new user
  end

  def menu
    shishas = Shisha.current
    if shishas.any?
      msg_lines = []
      shishas.each do |s|
        price = Setting.default_price
        msg_lines << "*#{price}* RUR: " + s.draw.participants(you: @user)
      end
      @text = "Currently smoking:\n" + msg_lines.map{ |l| '◦ ' + l }.join("\n")
    else
      @text = 'No one is smoking now'
    end
    @text << "\n\nMoney: *#{@user.money}* RUR"
    self
  end

  def tools
    @text = 'Tools'
    keyset = []
    keyset << Buttons.static(:create_free) if @user.super_admin?
    keyset << Buttons.static(:menu)
    self.keys = keyset
    self
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
    url = Rails.application.routes.url_helpers.auth_url(url_params)
    @parse_mode = 'HTML'
    @text = "The link is valid for one minute or a single login!\n#{url}"
    self
  end

  def history
    lines = []
    lines << 'Showing the last five items'
    lines << 'Check the web-interface for more'
    lines << ''
    @user.events.last(5).each do |event|
      line = event.change.negative? ? '😤' : '💰'
      line << "*#{format('%+d', event.change)}* RUR\n"
      line << '       ' + event.created_at.strftime('%a, %d %B %Y, %H:%M') + "\n"
      if event.shisha_id
        line << '       _'
        l = 'Alone'
        l = '⚠️ FREE' if event.shisha.free?
        mates = event.shisha.users.exclude(@user)
        if mates.any?
          l = 'Smoking with ' + mates.map(&:first_name).to_sentence
        end
        line << l
        line << "_\n"
      elsif event.comment
        line << '       _' + event.comment + "_\n"
      end
      line << "       Ballance: *#{event.current}* RUR\n"
      lines << line
    end
    @text = lines.any? ? lines.join("\n") : 'Your history is empty'
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
      parse_mode: @parse_mode
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
