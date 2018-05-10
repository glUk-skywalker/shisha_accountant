def kb(user)
  keyset = []

  if user.current_shisha
    keyset << [Buttons.static(:leave), Buttons.static(:finish)]
  else
    Shisha.joinable.each do |s|
      keyset << [Buttons.join_shisha(s)]
    end

    keyset << Buttons.static(:create) if Shisha.available?
  end

  keyset << Buttons.static(:refresh)
end
