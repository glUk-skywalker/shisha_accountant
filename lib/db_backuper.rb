class DBBackuper
  DUMP_FILENAME = 'sa.sql'.freeze

  def initialize
    @db_conf = Rails.application.config.database_configuration[Rails.env]
  end

  def self.backup!
    new.save_dump!.send_dump!
  end

  def bash_params
    [
      "-u#{@db_conf['username']}",
      "-p#{@db_conf['password']}",
      '--default-character-set=utf8',
      '--single-transaction=TRUE',
      '--routines',
      '--events',
      "\"#{@db_conf['database']}\" > #{Rails.root.join('tmp', DUMP_FILENAME)}"
    ]
  end

  def save_dump!
    `mysqldump #{bash_params.join(' ')}`
    self
  end

  def send_dump!
    token = Rails.application.secrets.bot_token
    User.super_admins.each do |admin|
      Telegram::Bot::Client.run(token) do |bot|
        Dir.chdir('tmp') do
          bot.api.send_document(message_params(admin))
        end
      end
    end
  end

  private

  def message_params(user)
    {
      chat_id: user.id,
      document: Faraday::UploadIO.new(DUMP_FILENAME, 'application/sql')
    }
  end
end
