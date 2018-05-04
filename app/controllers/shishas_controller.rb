class ShishasController < AuthenticatedUserController
  def new
    current_user.action.create_shisha
    redirect_to request.referer
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
end
