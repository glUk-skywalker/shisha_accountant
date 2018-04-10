class AuthenticatedUserController < ApplicationController
  before_action :authenticate!

  def authenticate!
    redirect_to signin_path unless current_user
  end
end
