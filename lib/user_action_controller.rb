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
  #
  # def join_shisha(shisha)
  #   if shisha && shisha.joinable_for?(user)
  #     UserShisha.create(user_id: id, shisha_id: shisha.id)
  #   end
  # end
  #
  #
  # def leave_shisha(shisha)
  #   if shisha && @user.current_shisha == shisha
  #     UserShisha.where(user_id: current_user.id, shisha_id: @shisha.id).first.destroy
  #     shisha.destroy unless @shisha.users.any?
  #   end
  # end
end
