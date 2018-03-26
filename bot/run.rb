puts "Loading Rails env..."
require File.expand_path('../../config/environment', __FILE__)
puts "Loaded!"

puts "Connectiong to the db..."
config = Rails.application.config.database_configuration[Rails.env]
ActiveRecord::Base.establish_connection(config)
puts "Connected!"

puts "Total rooms count: #{ Room.all.length }"
puts "Creating a new room..."
Room.create(name: "room one")
puts "Total roome count: #{ Room.all.length }"
puts "The last created room is: #{ Room.last.name }"
