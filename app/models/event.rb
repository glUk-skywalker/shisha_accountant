class Event < ApplicationRecord
  belongs_to :user
  belongs_to :shisha, optional: true
end
