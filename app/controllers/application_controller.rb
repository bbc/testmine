class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  
  private

  def current_user
    if request.headers['bbc.email_address']
      @current_user ||= User.find_or_create(
        :name => request.headers['bbc.name'], 
        :email => request.headers['bbc.email_address'] )
    end
  end
end
