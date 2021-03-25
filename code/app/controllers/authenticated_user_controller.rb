class AuthenticatedUserController < ApplicationController
  before_action :authenticate!, :check_allowed

  def authenticate!
    redirect_to signin_path unless current_user
  end

  def check_allowed
    render 'user_not_allowed' unless current_user.allowed?
  end
end
