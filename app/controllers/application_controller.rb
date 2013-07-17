class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_authentication

  helper_method :current_user

  protected
  
  def current_user
    @current_user ||= (User.find(session[:user]) if session[:user])
  end

	private

  def audio_document_url(*args)
    document_url *args
  end

  def check_authentication
    Rails.logger.debug "Format: #{request.format}, auth_token: #{params[:auth_token]}"

    unless current_user
      if request.format.in? [Mime::XML, Mime::ATOM, Mime::JSON]
        @current_user ||= User.authenticate_by_token params[:auth_token] if params[:auth_token]
        unless @current_user
          render :text => "HTTP API: Access denied.\n", :status => :unauthorized
        end
      else
        redirect_to :controller => "users", :action => "signin"
      end
    end
  end

end
