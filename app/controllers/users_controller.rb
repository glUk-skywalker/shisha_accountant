class UsersController < AuthenticatedUserController
  def show
    @user_shsihas = current_user.shishas.order(created_at: :desc).to_a
  end
end
