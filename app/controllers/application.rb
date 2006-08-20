# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	before_filter :check_authentication, :except => [:signup, :signin, :welcome, :index, :confirm, :play, :playlist, :feed]

	private
	def	check_authentication
		unless session[:user]
			redirect_to :controller => "users", :action => "signin"
		end
	end 
end
