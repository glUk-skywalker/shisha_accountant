class ShishasController < AuthenticatedUserController
  before_action :find_shisha, only: [:stop, :join, :leave]
  def new
    current_user.action.create_shisha
    redirect_to request.referer
  end

  def stop
    if @shisha && current_user.current_shisha == @shisha
      @shisha.stop!
    end
    redirect_to request.referer
  end

  def join
    current_user.action.join_shisha(@shisha)
    redirect_to request.referer
  end

  def leave
    if @shisha && current_user.current_shisha == @shisha
      UserShisha.where(user_id: current_user.id, shisha_id: @shisha.id).first.destroy
      @shisha.destroy unless @shisha.users.any?
    end
    redirect_to request.referer
  end

  private

  def find_shisha
    @shisha = Shisha.current.where(id: params[:shisha_id]).first
  end
end
