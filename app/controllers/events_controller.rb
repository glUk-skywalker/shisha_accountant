class EventsController < AuthenticatedUserController
  def new
    @user = User.find(params[:user_id])
    @event = @user.events.new
  end

  def create
    user = User.find(params[:user_id])
    user.change_money(event_params[:change].to_f, event_params[:comment])
    if params[:global]
      e = GlobalEvent.new(event_params)
      e.comment = '[' + user.first_name + '] ' + e.comment
      e.save
    end
    redirect_to users_path
  end

  def index
    @events = current_user.events.order(created_at: :desc)
  end

  private

  def event_params
    params.require(:event).permit([:change, :comment])
  end
end
