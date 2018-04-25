class ShishasController < AuthenticatedUserController
  def new
    if Shisha.available? && !current_user.current_shisha
      current_user.create_shisha
    end
    redirect_to request.referer
  end

  def stop
    s = Shisha.current.where(id: params[:id]).first
    s.stop! if s
    redirect_to request.referer
  end
end
