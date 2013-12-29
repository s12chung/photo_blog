class SessionController < ApplicationController
  def new
    if authenticated?; redirect_to root_path end
  end

  def create
    if params[:user] == "steve" && params[:password] == "secret"
      cookies[:auth_token] = Session.generate
      redirect_to root_path
    else
      render :new
    end
  end
end