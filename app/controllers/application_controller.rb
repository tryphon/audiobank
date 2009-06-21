# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	before_filter :check_authentication, :except => [:signup, :signin, :welcome, :index, :confirm, :play, :playlist, :feed, :begin, :complete, :recover_password]

  helper_method :current_user

  protected
  
  def current_user
    @current_user ||= User.find(session[:user])
  end

	private
	def	check_authentication
		unless current_user
			redirect_to :controller => "users", :action => "signin"
		end
	end
end
