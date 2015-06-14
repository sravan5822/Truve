class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user

  APN_POOL = ConnectionPool.new(:size => 2, :timeout => 300) do
    uri, certificate = if Rails.env.production?
      [Houston::APPLE_PRODUCTION_GATEWAY_URI,
       File.read("truve_push_production.pem")]
    else
      [Houston::APPLE_DEVELOPMENT_GATEWAY_URI,
       File.read("apple_push_notification_truve.pem")]
    end
    connection = Houston::Connection.new(uri, certificate, nil)
    connection.open
    connection
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

class Array
  def reverse_set_intersection(comparator)
    (self - (self & comparator)) | (comparator - (self & comparator))
  end
end
