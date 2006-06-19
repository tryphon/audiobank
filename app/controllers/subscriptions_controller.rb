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
  end
  
	def add
		@subscription = Subscription.new do |subscription|
    	subscription.author = Author.find(session[:user])
    	subscription.document = subscription.author.documents.find(params[:document])
    	subscription.subscriber = Subscriber.find(params[:id].split("_")[1])
    end
		@subscription.save
		@users = User.find(:all, :conditions => ["id != ?", session[:user]]) - @subscription.document.subscribers 
		render :action => "update"
	end
  
  def remove
    @subscription = Author.find(session[:user]).documents.find(params[:document]).subscriptions.find(:first, :conditions => ["author_id = ? AND subscriber_id = ?", session[:user], params[:id].split("_")[1]])
    @subscription.destroy
    @users = User.find(:all, :conditions => ["id != ?", session[:user]]) - @subscription.document.subscribers 
    render :action => "update"
  end
  
  def download
    @subscription = Subscriber.find(session[:user]).subscriptions.find(params[:id])
    @subscription.increment!(:download_count)
  	send_file @subscription.document.path, :type => @subscription.document.format
  end
end
