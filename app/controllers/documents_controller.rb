class DocumentsController < ApplicationController
  def index
    redirect_to :action => 'manage'
  end
  
  def add
    @document = AudioDocument.new(params[:document])
    if request.post?
      @document.author = Author.find(session[:user])
      @document.length = 0
      @document.size = 0
      @document.format = "unknow"
      if @document.save
        flash[:success] = "Votre document a bien été crée"
        redirect_to :action => 'share', :id => @document
      else
        flash[:failure] = "Votre document n'a pas été crée"
      end
    end
  end
    
  def edit
    @document = Author.find(session[:user]).documents.find(params[:id])
    if request.post?
      if @document.update_attributes(params[:document])
        flash[:success] = "Votre document a bien été édité"
        redirect_to :action => 'manage'
      else
        flash[:failure] = "Votre document n'a pas été édité"
      end
    end
  end

  def manage
    @document = Author.find(session[:user]).documents
  end
  
  def download
    
  end
  
  def upload
  	@document = Author.find(session[:user]).documents.find(params[:id])
  	if request.post?
  		@document.file = params[:file]
  	end
  end
  
  def destroy
    Author.find(session[:user]).documents.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end

  def share
  	@document = Author.find(session[:user]).documents.find(params[:id])
	  @user = User.find(:all, :conditions => ["id != ?", session[:user]]) - @document.subscribers
	end
end
