class UsersController < AuthenticatedUserController
  def show
    @user_current_shisha = current_user.current_shisha
    @user_shsihas = current_user.shishas.finished.order(created_at: :desc).eager_load(:users).to_a
  end

  def index
    @users = User.all.order(money: :asc)
  end

  def update
    if current_user.super_admin?
      user = User.find(params[:id])
      user.update_attributes(allowed: user_params[:allowed])
    end
    redirect_to request.referer
  end

  private

  def user_params
    params.permit(:allowed)
  end
end
