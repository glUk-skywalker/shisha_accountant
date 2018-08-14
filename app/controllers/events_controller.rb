class EventsController < AuthenticatedUserController
  def new
    @user = User.find(params[:user_id])
    @event = @user.events.new
  end

  def create
    user = User.find(params[:user_id])
    user.change_money(event_params[:change].to_f, event_params[:comment])
    redirect_to users_path
  end

  private

  def event_params
    params.require(:event).permit([:change, :comment])
  end
end