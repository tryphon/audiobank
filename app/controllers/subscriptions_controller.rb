class SubscriptionsController < ApplicationController
  layout 'documents'
  
  def index
    redirect_to :action => 'manage'
  end
  

	def manage
		@pages = Paginator.new(self, User.find(session[:user]).find_subscriptions.size, 4, params[:page])
		@subscription = User.find(session[:user]).find_subscriptions(:limit => @pages.items_per_page, :offset => @pages.current.offset)
	end 
  
  def show
  	@subscription = User.find(session[:user]).find_subscription(params[:id])
  	@review = Review.new(params[:review])
  	if request.post?
  		@review.document = @subscription.document
  		@review.user = User.find(session[:user])
  		if @review.save
  			flash[:success] = "Votre commentaire a bien été ajouté" 
  			redirect_to :action => 'show', :id => @subscription 
  		else
  			flash[:failure] = "Votre commentaire n'a pas été ajouté"
  		end
    else
    	@review.rating = 3
  	end
  end
  
	def add
	  document_id = params[:document]
	  subscriber_type, subscriber_id = params[:id].split("_")
	  
		@subscription = Subscription.new do |subscription|
    	subscription.author = User.find(session[:user])
    	subscription.document = subscription.author.documents.find(document_id)
    	subscription.subscriber = Object.const_get(subscriber_type.capitalize).find(subscriber_id)
    end
		
		unless @subscription.save
		  logger.error("can't create subscription on #{document_id} for #{subscriber_type}:#{subscriber_id} : #{@subscription.errors.inspect}")
		end
		
		render :action => "update"
	end
  
  def remove
    @subscription = User.find(session[:user]).documents.find(params[:document]).subscriptions.find(:first, :conditions => ["author_id = ? AND subscriber_id = ?", session[:user], params[:id].split("_")[1]])
    @subscription.destroy
    render :action => "update"
  end
  
  def tag
  	@pages = Paginator.new(self, User.find(session[:user]).find_subscriptions(:tag => params[:name]).size, 4, params[:page])
  	@subscriptions = User.find(session[:user]).find_subscriptions(:tag => params[:name], :offset => @pages.current.offset, :limit => @pages.items_per_page)
  end
  
  def download
    @subscription = User.find(session[:user]).find_subscription(params[:id])
    @subscription.increment!(:download_count)
  	send_file @subscription.document.path, :type => @subscription.document.format, :filename => @subscription.document.filename
  end
  
end
