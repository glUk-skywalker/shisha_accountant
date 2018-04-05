def new_shisha_available?
  Shisha.current.length < Setting.max_shisha_count
end
