class UsersController < ApplicationController
	open_id_consumer :required => [:email, :nickname], :optional => [:fullname, :dob, :gender, :country]
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
		@tag = @subscriber.subscriptions.collect{ |s| s.document.tags } + @author.documents.collect{ |d| d.tags }
		@tag = @tag.flatten.uniq[0..15]
	end
	
	def tags
	  @author = Author.find(session[:user])
		@subscriber = Subscriber.find(session[:user])
	  @tag = @subscriber.subscriptions.collect{ |s| s.document.tags } + @author.documents.collect{ |d| d.tags }
		@tag = @tag.flatten.uniq
	end
	
	def tag
		@document = Author.find(session[:user]).documents.find_by_tag(params[:name], { :limit => 5 })
		@subscription = Subscriber.find(session[:user]).subscriptions.find_by_tag(params[:name], { :limit => 5 })
	end
	
	def find
		@document = Author.find(session[:user]).documents.find_by_keywords(params[:keywords])
		@subscription = Subscriber.find(session[:user]).subscriptions.find_by_keywords(params[:keywords])
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
    	@user.confirmed = false
      if @user.save
	      Mailer::deliver_confirm(@user, self)
      	flash[:success] = "Votre compte a bien été crée"
        flash[:notice] = "Un email de confirmation vous a été envoyé"
        redirect_to :action => "signin"
      else
      	@user.password = ""
        flash[:failure] = "Votre compte n'a pas été crée"
		  end
    end  
  end
  
  def confirm
  	@user = User.find(params[:id])
  	if @user.hashcode == params[:confirm] && !@user.confirmed?
  		@user.update_attribute(:confirmed, true)
	  	Subscriber.find(@user.id).subscriptions.build(:author => Author.find(1), :document => Document.find(1)).save
	  	flash[:success] = "Bienvenue !"
	    session[:user] = @user.id
	  	redirect_to :action => "dashboard"
	  else
	  	flash[:failure] = "La création de votre compte n'a pas été confirmé"
	  	redirect_to :action => "signup"
	  end
  end

	def begin
    case open_id_response.status
      when OpenID::SUCCESS
        redirect_to open_id_response.redirect_url((request.protocol + request.host_with_port + '/'), url_for(:action => 'complete'))
      else
        flash[:failure] = "Impossible de trouver un server openid à l'adresse #{params[:openid_url]}"
        render :action => :signin
    end
  end

  def complete
    case open_id_response.status
      when OpenID::FAILURE
        flash[:failure] = "Votre identification a échoué"
       
      when OpenID::SUCCESS
        @user = User.find_or_initialize_by_openid_url(open_id_response.identity_url)
        if @user.new_record?
        	@user.email = open_id_fields["email"]
        	@user.confirmed = true
        	@user.name = open_id_fields["nickname"]
        	@user.name = open_id_fields["fullname"] if open_id_fields.has_key?("fullname")
        	@user.save
        end
        flash[:success] = "Bienvenue !"
       	session[:user] = @user.id
    
      when OpenID::CANCEL
        flash[:failure] = "Votre identification a été annulé"
    
      else
        flash[:failure] = "Voter identification a échoué : #{open_id_response.status}"
    end
    redirect_to :action => 'dashboard'
  end

	def signout
		session[:user] = nil
		flash[:success] = "A bientôt !"
		redirect_to :action => "welcome"
	end 
end
