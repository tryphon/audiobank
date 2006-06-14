class DocumentsController < ApplicationController
  def index
    redirect_to :controller => 'users', :action => 'dashboard'
  end
  
  def create
    @document = AudioDocument.new(params[:document])
    if request.post?
      @document.author = Author.find(session[:user])
      @document.length = 0
      @document.size = 0
      @document.format = "unknow"
      if @document.save
        flash[:success] = "Votre document a bien été crée"
        redirect_to :action => 'index'
      else
        flash[:failure] = "Votre document n'a pas été crée"
      end
    end
  end
  
  def edit 
  	@document = AudioDocument.find(params[:id])
		if request.post?
			if @document.update_attributes(params[:document])
				flash[:success] = "Le document a bien été modifié"
			else
				flash[:failure] = "Le document n'a pu être modifié"
			end
		end
  end
  
  def share
  	@document = AudioDocument.find(params[:id])
		@user = User.find(session[:user])
	  @users = User.find(:all, :conditions => ["id != ?", @user.id])
	  
	  @subscription = Subscription.new(params[:subscription])
	  @subscription.document = @document
	  # check if @user == @document.author ?
	  @subscription.author = @subscription.document.author;
	  
	  # to be continued :o)
	end  	
end
