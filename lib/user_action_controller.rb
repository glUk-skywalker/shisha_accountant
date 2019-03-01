class UserActionController
  def initialize(user)
    @user = user
  end

  def create_shisha
    return unless Shisha.available? && !@user.current_shisha
    s = Shisha.create(price: Shisha.price)
    UserShisha.create(user_id: @user.id, shisha_id: s.id)
    User.ready.notified.each do |user|
      user.message.join_offer(@user, s).send!
    end
  end

  def create_free_shisha
    s = Shisha.create(price: Shisha.price, free: true)
    UserShisha.create(user_id: @user.id, shisha_id: s.id)
    s.stop!
  end

  def join_shisha(shisha)
    return unless shisha&.joinable_for?(@user) && !@user.current_shisha
    UserShisha.create(user_id: @user.id, shisha_id: shisha.id)
  end

  def leave_shisha
    s = @user.current_shisha
    return unless s
    UserShisha.where(user_id: @user.id, shisha_id: s.id).first.destroy
    s.destroy unless s.users.any?
  end

  def stop_shisha
    s = @user.current_shisha
    return unless s
    s.stop!
    @user.reload
    s.users.exclude(@user).notified.each do |user|
      user.message.text = 'Your shisha has been stopped'
      user.message.send!
    end
  end

  def set_notify(flag)
    @user.update_attributes(notify: flag)
    @user.message.text = "Notifications are *#{flag ? 'ON' : 'OFF'}*"
    @user.message.send!
  end
end
