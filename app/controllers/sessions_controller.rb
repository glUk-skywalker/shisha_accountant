class SessionsController < ApplicationController
  def new
    redirect_to :root if current_user
  end

  def create
    if params[:login_token]
      t = LoginToken.where(token: params[:login_token][:token]).first
      unless t
        flash[:error] = 'The token you have passed doesn\'t exist'
        redirect_to signin_path
        return
      end
      if (Time.now - t.updated_at) > Setting.login_token_expires_in
        flash[:error] = 'The token you have passed has expired'
        redirect_to signin_path
        return
      end
      user = t.user
      t.destroy
    else
      user = User.where(id: params[:id]).first
      if user
        user.update_attributes(user_params)
      else
        user = User.create(user_params)
      end
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
