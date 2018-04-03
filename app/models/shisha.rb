class Shisha < ApplicationRecord
  scope :current, -> { where(current: true) }
end
