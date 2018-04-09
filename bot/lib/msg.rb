def msg(user)
  if !user.allowed
    msg =
    <<~HEREDOC
      Sorry.. You are not allowed to use this bot yet :(
      The request on your participation has been sent to the owner.
      Please, wait until he accepts it.
      Thanks for you patience! :)
    HEREDOC
    return msg
  end

  msg_lines = []
  Shisha.current.each do |s|
    shisha_users = s.users
    if shisha_users.include?(user)
      other_users = shisha_users - [user]
      msg_lines << (["You"] + other_users.map(&:first_name)).to_sentence
    else
      msg_lines << shisha_users.map(&:first_name).to_sentence
    end
  end

  msg = if msg_lines.any?
    "Currently smoking:\n" + msg_lines.map{ |l| '◦ ' + l }.join("\n")
  else
    "No one is smoking now"
  end

  msg << "\n\nMoney: #{user.money}"
end
