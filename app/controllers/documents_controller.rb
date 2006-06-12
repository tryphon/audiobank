class DocumentsController < ApplicationController
	def dashboard
		@author = Author.find(session[:user])
		@subscriber = Subscriber.find(session[:user])
	end 
end
