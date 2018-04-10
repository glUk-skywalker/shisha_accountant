class SessionsController < ApplicationController
  def new
    # redirect_to '' unless current_user
  end

  def create
    user = User.where(id: params[:id]).first
    user ||= User.create(params.slice(:id, :first_name, :last_name, :username))
    session[:current_user_id] = user.id
    redirect_to :root
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to signin_path
  end
end
