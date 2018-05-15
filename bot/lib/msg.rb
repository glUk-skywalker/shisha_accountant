def msg(user)
  return not_allowed_user_message unless user.allowed?

  msg_lines = []
  Shisha.current.each do |s|
    msg_lines << s.draw.participants(you: user)
  end

  msg = if msg_lines.any?
    "Currently smoking:\n" + msg_lines.map{ |l| '◦ ' + l }.join("\n")
  else
    'No one is smoking now'
  end

  msg << "\n\nMoney: *#{user.money}* RUR"
end
