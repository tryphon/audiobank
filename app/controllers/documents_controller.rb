# -*- coding: utf-8 -*-
class DocumentsController < ApplicationController
	layout 'documents', :except => [:auto_complete_for_tags]

  def index
    redirect_to :action => 'manage'
  end

  def add
    @document = AudioDocument.new(params[:document])
    if request.post?
      @document.author = User.find(session[:user])
    	@document.tag_with(params[:labels])
      if @document.save
        flash[:success] = "Votre document a bien été crée"
        redirect_to :action => 'upload', :id => @document
      else
        flash[:failure] = "Votre document n'a pas été crée"
      end
    end
  end

  def show
  	@document = User.find(session[:user]).documents.find(params[:id], :include => :tags)
  	@review = Review.new(params[:review])
  	if request.post?
  		@review.document = @document
  		@review.user = User.find(session[:user])
  		if @review.save
  			flash[:success] = "Votre commentaire a bien été ajouté"
  			redirect_to :action => 'show', :id => @document
  		else
  			flash[:failure] = "Votre commentaire n'a pas été ajouté"
  		end
    else
    	@review.rating = 3
  	end
  end

  def edit
    @document = User.find(session[:user]).documents.find(params[:id])
    if request.post?
    	@document.tag_with(params[:labels])
      if @document.update_attributes(params[:document])
        flash[:success] = "Votre document a bien été édité"
        redirect_to :action => 'show', :id => @document
      else
        flash[:failure] = "Votre document n'a pas été édité"
      end
    end
  end

	def manage
		@documents = User.find(session[:user]).documents.paginate :page => params[:page], :per_page => 4
	end

  def upload
  	@document = User.find(session[:user]).documents.find(params[:id])
  	unless @document.upload
	  	@document.upload = Upload.new
	  	@document.save
	  end

  	if request.post?
  		if params[:mode] == "ftp"
	  		logger.info "FTP upload from #{@document.upload}"
  			unless @document.upload.empty?
	  			upload_file = @document.upload.file
	  		else
	  			flash[:failure] = "Votre fichier n'a pas été trouvé dans le répertoire ftp"
	  			return
	  		end
			else
				upload_file = params[:document][:file]
			end

			begin
				logger.debug "Upload file: #{upload_file.inspect}"
				uploaded = @document.upload_file(upload_file)
			rescue Exception => e
 				logger.error("Can't upload #{upload_file.to_s}: #{e}")
			end

			if uploaded
				@document.upload = nil
  			@document.save
  			flash[:success] = "Votre fichier a bien été déposé"
  			redirect_to :action => 'share', :id => @document
  		else
  			flash[:failure] = "Votre fichier n'a pas été déposé"
  			redirect_to :action => 'upload', :id => @document
  		end
  	end
  end

  def download
  	@document = User.find(session[:user]).documents.find(params[:id])
  	send_file @document.path, :type => @document.format, :filename => @document.filename
  end

  def destroy
    User.find(session[:user]).documents.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end

  def share
  	@document = User.find(session[:user]).documents.find(params[:id])
	  flash[:warning] = "Votre document n'est lié à aucun fichier" unless @document.uploaded?
	end

	def tag
		@documents = User.find(session[:user]).documents.find_by_tag(params[:name]).paginate(:page => params[:page], :per_page => 4)
	end

	def auto_complete_for_tags
		@tag = Tag.find(:all, :conditions => ["name ~* ?", params[:labels]])
	end

  def listen
  	@document = User.find(session[:user]).documents.find(params[:id])
  	redirect_to :controller => 'casts', :action => 'play', :name => @document.casts.first.name
	end

  def search_nonsubscribers
    input = params[:input].nil? ? "" : params[:input].downcase
    id = params[:id]

    @people = Document.find(id).nonsubscribers.delete_if do |people|
      ! people.match_name?(input)
    end
    render :partial => "users/people", :object => @people, :locals => { :empty => "Aucun utilisateur ne correspond", :draggable => true }
  end
end
