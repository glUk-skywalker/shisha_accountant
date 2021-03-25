puts 'Loading Rails env...'
require File.expand_path('../../config/environment', __FILE__)
puts 'Loaded!'

puts 'Connecting to the db...'
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts 'Connected!'

loop do
  Shisha.stop_old!

  # TODO
  # DBBackuper.backup!
  # User.remind_debtors!

  sleep 60
end
