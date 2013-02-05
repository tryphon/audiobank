class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_authentication

  helper_method :current_user

  protected
  
  def current_user
    @current_user ||= (User.find(session[:user]) if session[:user])
  end

	private

	def	check_authentication
    case request.format
    when Mime::XML, Mime::ATOM, Mime::JSON
      unless current_user
        if user = authenticate_with_http_basic { |username, password| User.authenticate(username, password) }
          @current_user = user
        else
          request_http_basic_authentication
        end
      end
    else
      unless current_user
        redirect_to :controller => "users", :action => "signin"
      end
    end
	end

end
