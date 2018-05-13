class UsersController < AuthenticatedUserController
  def show
    @user_current_shisha = current_user.current_shisha
    @user_shsihas = current_user.shishas.finished.order(created_at: :desc).eager_load(:users).to_a
  end

  def index
    @users = User.all.order(money: :asc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    u = User.find(params[:id])
    u.add_money(params[:user][:money].to_f)
    redirect_to users_path
  end
end
