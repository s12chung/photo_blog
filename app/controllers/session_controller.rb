class SessionController < ApplicationController
  def new
    if authenticated?; redirect_to root_path end
  end

  def create
    auth_token = Session.authenticate params[:username], params[:password]
     if auth_token
      cookies[:auth_token] = auth_token
      redirect_to root_path
    else
      render :new
    end
  end
end