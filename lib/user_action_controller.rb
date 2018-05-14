class UserActionController
  def initialize(user)
    @user = user
  end

  def create_shisha
    return unless Shisha.available? && !@user.current_shisha
    s = Shisha.create(price: Setting.default_price)
    UserShisha.create(user_id: @user.id, shisha_id: s.id)
    User.notified.each do |user|
      user.message.join_offer(@user, s).send!
    end
  end

  def join_shisha(shisha)
    return unless shisha&.joinable_for?(@user)
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
  end

  def set_notify(flag)
    @user.update_attributes(notify: flag)
    @user.message.text = "Notifications are *#{flag ? 'ON' : 'OFF'}*"
    @user.message.send!
  end
end
