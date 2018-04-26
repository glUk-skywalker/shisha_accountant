class UsersController < AuthenticatedUserController
  def show
    @user_shsihas = current_user.shishas.order(created_at: :desc).eager_load(:users).to_a
  end

  def index
    @users = User.all.order(money: :asc)
  end
end
