class SubscriptionsController < ApplicationController
  layout 'documents'
  
  def index
    redirect_to :action => 'manage'
  end

  def manage
    @subscription = Subscriber.find(session[:user]).subscriptions
  end  
end
