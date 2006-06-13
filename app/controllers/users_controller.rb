class UsersController < ApplicationController
	layout 'documents'
	
	def index
		welcome
		render(:action => "welcome")
	end
	
	def welcome
		# could be remove if no one find something to put in
	end

 	def dashboard
		@author = Author.find(session[:user])
		@subscriber = Subscriber.find(session[:user])
	end
	
	def options
		@user = User.find(session[:user])
	  @users = User.find(:all, :conditions => ["id != ?", @user.id])
		if request.post?
			if @user.update_attributes(params[:user])
				flash[:success] = "Vos informations ont bien été modifié"
			else
				flash[:failure] = "Vos informations n'ont pas été modifié"
			end
		end
	end
	
	def signin
		@user = User.new
		if request.post?
			@user = User.authenticate(params[:user])
			unless @user.blank?
				flash[:success] = "Bienvenue !"
				session[:user] = @user.id
				redirect_to :action => "dashboard"
			else
				flash[:failure] = "Mauvais nom d'utilisateur ou mot de passe"
			end
		end
	end
	
  def signup
    @user = User.new(params[:user])
    if request.post? 
      if @user.save
        flash[:success] = "Votre compte a bien été crée"
      else
        flash[:failure] = "Votre compte n'a pas été crée"
		  end
    end  
  end

	def	signout
		session[:user] = nil
		redirect_to :action => "welcome"
	end 
end
