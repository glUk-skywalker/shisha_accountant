class LoginToken < ApplicationRecord
  belongs_to :user
  before_save :generate_token

  def generate_token
    assign_attributes(token: SecureRandom.hex(50))
  end
end
