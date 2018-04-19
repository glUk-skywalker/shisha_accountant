class SessionsController < ApplicationController
  def new
    redirect_to :root if current_user
  end

  def create
    user = User.where(id: params[:id]).first
    if user
      user.update_attributes(user_params)
    else
      user = User.create(user_params)
    end
    session[:current_user_id] = user.id
    redirect_to :root
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to signin_path
  end

  private

  def user_params
    params.permit(:id, :first_name, :last_name, :username, :photo_url)
  end
end
