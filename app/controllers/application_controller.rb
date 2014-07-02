class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :authenticated?
  helper_method :user_agent

  def markdown
    @markdown = Markdown.where(key: params[:key]).first
  end

  protected
  def authorize
    unless authenticated?
      redirect_to login_path
    end
  end
  def authenticated?
    if @authenticated.nil?
      @authenticated = Session.authenticated? cookies[:auth_token]
    else
      !!@authenticated
    end
  end

  def user_agent; @user_agent ||= UserAgent.parse(request.env["HTTP_USER_AGENT"]) end
end
