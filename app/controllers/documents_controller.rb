class DocumentsController < ApplicationController
	def dashboard
		@author = Author.find(session[:user])
		@subscriber = Subscriber.find(session[:user])
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
end
