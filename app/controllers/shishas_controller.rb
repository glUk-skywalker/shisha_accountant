class ShishasController < AuthenticatedUserController
  def new
    if Shisha.available? && !current_user.current_shisha
      current_user.create_shisha
    end
    redirect_to request.referer
  end
end
