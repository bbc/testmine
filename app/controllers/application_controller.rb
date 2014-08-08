class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :authenticate
  def authenticate
    @username = request.headers['bbc.name']
    @email_address = request.headers['bbc.email_address']
  end
end
