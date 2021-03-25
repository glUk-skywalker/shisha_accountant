class ShishaDecorator
  def initialize(shisha)
    @shisha = shisha
  end

  def participants(you: nil)
    shisha_users = @shisha.users
    if shisha_users.include?(you)
      other_users = shisha_users - [you]
      (['You'] + other_users.map(&:first_name)).to_sentence
    else
      shisha_users.map(&:first_name).to_sentence
    end
  end
end
