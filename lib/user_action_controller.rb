class UserActionController
  def initialize(user)
    @user = user
  end

  def create_shisha
    if Shisha.available? && !@user.current_shisha
      s = Shisha.create(price: Setting.default_price)
      UserShisha.create(user_id: @user.id, shisha_id: s.id)
    end
  end

  def join_shisha(shisha)
    if shisha && shisha.joinable_for?(@user)
      UserShisha.create(user_id: @user.id, shisha_id: shisha.id)
    end
  end

  def leave_shisha
    s = @user.current_shisha
    if s
      UserShisha.where(user_id: @user.id, shisha_id: s.id).first.destroy
      s.destroy unless s.users.any?
    end
  end

  def stop_shisha
    s = @user.current_shisha
    if s
      s.stop!
      @user.reload
    end
  end
end
