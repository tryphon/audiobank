# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable

	before_filter :check_authentication, :except => [:signup, :signin, :welcome, :index, :confirm, :play, :playlist, :feed, :begin, :complete, :recover_password]

  helper_method :current_user

  protected
  
  def current_user
    @current_user ||= (User.find(session[:user]) if session[:user])
  end

	private

	def	check_authentication
    case request.format
    when Mime::XML, Mime::ATOM, Mime::JSON
      if user = authenticate_with_http_basic { |username, password| User.authenticate(username, password) }
        @current_user = user
      else
        request_http_basic_authentication
      end
    else
      unless current_user
        redirect_to :controller => "users", :action => "signin"
      end
    end
	end
end
