class UsersController < AuthenticatedUserController
  def show
    @user_shsihas = current_user.shishas.to_a
  end
end
