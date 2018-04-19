def kb(user)
  return [button(:refresh)] unless user.allowed
  keyset = []

  s = user.current_shisha
  if s
    keyset << [button(:leave), button(:finish)]
  else
    Shisha.joinable.each do |s|
      button_params = {
        text: "Join #{ s.users.map(&:first_name).to_sentence }",
        callback_data: "join:#{ s.id }"
      }
      keyset << [
        Telegram::Bot::Types::InlineKeyboardButton.new(button_params)
      ]
    end

    keyset << button(:create) if Shisha.available?
  end

  keyset << button(:refresh)
end
