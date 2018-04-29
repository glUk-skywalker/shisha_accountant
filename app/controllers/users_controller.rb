class UsersController < AuthenticatedUserController
  def show
    @user_shsihas = current_user.shishas.order(created_at: :desc).eager_load(:users).to_a
  end

  def index
    @users = User.all.order(money: :asc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    u = User.find(params[:id])
    u.money = u.money + params[:user][:money].to_f
    u.save
    redirect_to users_path
  end
end
