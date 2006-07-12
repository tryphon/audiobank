class SubscriptionsController < ApplicationController
  layout 'documents'
  
  def index
    redirect_to :action => 'manage'
  end

	def manage
		@subscription = Subscriber.find(session[:user]).subscriptions
	end 
  
  def show
  	@subscription = Subscriber.find(session[:user]).subscriptions.find(params[:id])
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
  	end
  end
  
	def add
		@subscription = Subscription.new do |subscription|
    	subscription.author = Author.find(session[:user])
    	subscription.document = subscription.author.documents.find(params[:document])
    	subscription.subscriber = Subscriber.find(params[:id].split("_")[1])
    end
		@subscription.save
		render :action => "update"
	end
  
  def remove
    @subscription = Author.find(session[:user]).documents.find(params[:document]).subscriptions.find(:first, :conditions => ["author_id = ? AND subscriber_id = ?", session[:user], params[:id].split("_")[1]])
    @subscription.destroy
    render :action => "update"
  end
  
  def tags
  	@subscriptions = Subscriber.find(session[:user]).subscriptions.find_by_tag(params[:name])
  end
  
  def download
    @subscription = Subscriber.find(session[:user]).subscriptions.find(params[:id])
    @subscription.increment!(:download_count)
  	send_file @subscription.document.path, :type => @subscription.document.format, :filename => @subscription.document.filename
  end
end
