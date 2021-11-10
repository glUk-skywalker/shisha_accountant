# frozen_string_literal: true

puts 'Loading Rails env...'
require File.expand_path('../../config/environment', __FILE__)
puts 'Loaded!'

puts 'Connecting to the db...'
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts 'Connected!'

TIME_FILEPATH = Rails.root.join('tmp', 'backup.time')

def backup_now?
  last_time = Time.parse File.read(TIME_FILEPATH)
  return false if (Time.now - last_time) < 60 * 60 * 24

  Shisha.finished.last.updated_at > last_time
rescue
  true
end

loop do
  sleep 60
  next unless backup_now?

  DBBackuper.backup!
  File.open(TIME_FILEPATH, 'w') { |f| f.write Time.now.to_s }
end
