def msg(user)
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

  if msg_lines.any?
    "Currently smoking:\n" + msg_lines.map{ |l| '◦ ' + l }.join("\n")
  else
    "No one is smoking now"
  end
end
