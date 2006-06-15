class BasketController < ApplicationController
  def list
    init
    session[:basket].delete_if { |id| !Document.exists?(id) }
    logger.info(session[:basket].inspect)
    @document = Array.new
    session[:basket].each do |event|
      @document << Document.find(event)
    end  
  end 
  
  def put
    init
    session[:basket] << params[:id] if Document.exists?(params[:id])
    redirect_to(:action => "list")
  end
  
  def remove
    session[:basket].delete(params[:id]) unless session[:basket].nil?
    redirect_to(:action => "list")
  end
  
  private
  def init
    session[:basket] = Set.new if session[:basket].nil?
  end
end
