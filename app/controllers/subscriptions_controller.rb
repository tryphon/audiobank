class SubscriptionsController < ApplicationController
  layout 'documents'
  
  def index
    redirect_to :action => 'manage'
  end

  def manage
    @document = Subscriber.find(session[:user]).documents
  end 
  
  def show
  	@document = Subscriber.find(session[:user]).documents.find(params[:id])
  end
  
  def add
    @document = Document.find(params[:document])
    @subscription = Subscription.new(:author => Author.find(session[:user]), :document => @document, :subscriber => Subscriber.find(params[:id].split("_")[1]))
    @subscription.save
    @users = User.find(:all, :conditions => ["id != ?", session[:user]]) - @document.subscribers 
    render :action => "update"
  end
  
  def remove
    @document = Document.find(params[:document])
    @subscription = @document.subscriptions.find(:first, :conditions => ["author_id = ? AND subscriber_id = ?", session[:user], params[:id].split("_")[1]])
    @subscription.destroy
    render :action => "update"
  end
  
  def download
  	@document = Subscriber.find(session[:user]).documents.find(params[:id])
  	send_file @document.path, :type => @document.format
  end
end
