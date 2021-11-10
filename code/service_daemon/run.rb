require File.expand_path('../../config/environment', __FILE__)

logger = Logger.new("#{Rails.root}/log/service_daemon.log")
logger.info 'Rails environment has been successfully loaded!'

config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
logger.info 'DB connection has been successfully established!'

$debtors_reminded = false

def time_to_remind_debtors?
  time = Time.now

  $debtors_reminded = false if time.hour >= 20

  return false if $debtors_reminded

  return false if time.saturday? || time.sunday?

  time.hour == 19
end

loop do
  sleep 60

  Shisha.stop_old!

  if time_to_remind_debtors?
    logger.info 'reminding debtors..'
    User.remind_debtors!
    $debtors_reminded = true
  end
end
