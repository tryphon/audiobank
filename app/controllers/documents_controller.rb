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
      @document.format = "application/octet-stream"
      if @document.save
        flash[:success] = "Votre document a bien été crée"
        redirect_to :action => 'upload', :id => @document
      else
        flash[:failure] = "Votre document n'a pas été crée"
      end
    end
  end
  
  def show 
  	@document = Author.find(session[:user]).documents.find(params[:id])
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
  
  def upload
  	@document = Author.find(session[:user]).documents.find(params[:id])
  	if request.post?
  		unless params[:document][:file].is_a?(StringIO)
  			@document.file = params[:document][:file]
  			@document.save
  			flash[:success] = "Votre fichier a bien été déposé"
  			redirect_to :action => 'share', :id => @document
  		else
  			flash[:failure] = "Votre fichier n'a pas été déposé"
  		end
  	end
  end
  
  def download
  	@document = Author.find(session[:user]).documents.find(params[:id])
  	send_file @document.path, :type => @document.format
  end
  
  def destroy
    Author.find(session[:user]).documents.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end

  def share
  	@document = Author.find(session[:user]).documents.find(params[:id])
	  @user = User.find(:all, :conditions => ["id != ?", session[:user]]) - @document.subscribers
	  flash[:warning] = "Vos partages ne seront effectifs que lorsque le document sera lié à un fichier" unless @document.uploaded?
	end
end
