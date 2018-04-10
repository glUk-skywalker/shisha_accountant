class UsersController < AuthenticatedUserController
  def show
    @user = current_user
  end
end
