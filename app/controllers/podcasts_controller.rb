class PodcastsController < ApplicationController
  layout 'documents', :except => [:feed]
	
  def index
    redirect_to :action => 'manage'
  end
  
  def add
    @podcast = Podcast.new(params[:podcast])
    if request.post?
      @podcast.author = User.find(session[:user])
    	@podcast.tag_with(params[:labels])
    	@podcast.name = StringRandom.alphanumeric(8).downcase
      if @podcast.save
        flash[:success] = "Votre podcast a bien été crée"
        redirect_to :action => 'show', :id => @podcast
      else
        flash[:failure] = "Votre podcast n'a pas été crée"
      end
    end
  end
  
  def show 
  	@podcast = User.find(session[:user]).podcasts.find(params[:id], :include => :tags)
  end
    
  def edit
    @podcast = User.find(session[:user]).podcasts.find(params[:id])
    if request.post?
    	@podcast.tag_with(params[:labels])
      if @podcast.update_attributes(params[:document])
        flash[:success] = "Votre podcast a bien été édité"
        redirect_to :action => 'show', :id => @podcast
      else
        flash[:failure] = "Votre podcast n'a pas été édité"
      end
    end
  end

	def manage
		@pages = Paginator.new(self, User.find(session[:user]).podcasts.size, 4, params[:page])
		@podcast = User.find(session[:user]).podcasts.find(:all, :limit => @pages.items_per_page, :offset => @pages.current.offset, :include => :tags)
	end
    
  def destroy
    User.find(session[:user]).podcasts.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end
  
  def feed
  	@podcast = Podcast.find_by_name(params[:name])
  	render :content_type => "application/rss+xml"
  end
end
