class ShishasController < AuthenticatedUserController
  before_action :get_users, only: [:new_custom, :create]
  def new
    current_user.action.create_shisha
    redirect_to request.referer
  end

  def create
    @shisha = Shisha.new(shisha_params)
    if params[:users].length > Setting.max_shisha_slots
      flash[:error] = "Too many users (max: #{Setting.max_shisha_slots})"
      render 'new_custom'
    else
      @shisha.save
      @shisha.append_users(params[:users])
      @shisha.stop!
      redirect_to :root
    end
  end

  def new_custom
    @shisha = Shisha.new
  end

  def stop
    current_user.action.stop_shisha
    redirect_to request.referer
  end

  def join
    s = Shisha.current.where(id: params[:shisha_id]).first
    current_user.action.join_shisha(s)
    redirect_to request.referer
  end

  def leave
    current_user.action.leave_shisha
    redirect_to request.referer
  end

  private

  def get_users
    @users = User.all
  end

  def shisha_params
    p = params.require(:shisha).permit(:created_at)
    p.merge(price: Setting.default_price)
  end
end
