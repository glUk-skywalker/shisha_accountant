class Event < ApplicationRecord
  belongs_to :user
  belongs_to :shisha, optional: true

  def shisha
    Shisha.unscoped { super }
  end
end
