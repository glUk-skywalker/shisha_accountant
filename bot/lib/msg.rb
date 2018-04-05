def msg(user)
  s = user.current_shisha
  msg = if s
    other_users = s.users.to_a - [user]
    if other_users.any?
      "You are smoking with #{ other_users.map(&:first_name).to_sentence }"
    else
      "You are smoking alone"
    end
  else
    "Join the fellas or set up a new shisha!!"
  end

  msg + "\n\nMoney: #{ user.money }"
end
