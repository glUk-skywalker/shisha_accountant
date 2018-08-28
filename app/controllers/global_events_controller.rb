class GlobalEventsController < AuthenticatedUserController
  def index
    @events = GlobalEvent.all.order(created_at: :desc)
  end

  def new
    @event = GlobalEvent.new
  end

  def create
    GlobalEvent.create(event_params)
    redirect_to global_events_path
  end

  private

  def event_params
    params.require(:global_event).permit([:change, :comment])
  end
end