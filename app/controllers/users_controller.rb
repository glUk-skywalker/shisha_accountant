class UsersController < AuthenticatedUserController
  def show
    @user_shsihas = current_user.shishas.to_a
    @current_shisha = current_user.current_shisha
  end
end
