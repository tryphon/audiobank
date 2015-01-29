# -*- coding: utf-8 -*-
class LegacyDocumentsController < ApplicationController
	layout nil, :only => [:auto_complete_for_tags]

  def index
    redirect_to :action => 'manage'
  end

  def add
    @document = current_user.documents.build(params[:document])
    if request.post?
    	@document.tag_with(params[:labels]) if params[:labels].present?
      if @document.save
        # FIXME Sorry for kitten :(
        unless request.format == Mime::JSON
          flash[:success] = "Votre document a bien été crée"
          redirect_to :action => 'upload', :id => @document
        else
          render :json => @document
        end
      else
        unless request.format == Mime::JSON
          flash[:failure] = "Votre document n'a pas été crée"
        else
          render :json => @document, :status => [406, "Invalid entity"]
        end
      end
    end
  end

  def show
  	@document = current_user.documents.find(params[:id], :include => :tags)
  	@review = Review.new(params[:review])
  	if request.post?
  		@review.document = @document
  		@review.user = current_user
  		if @review.save
  			flash[:success] = "Votre commentaire a bien été ajouté"
  			redirect_to :action => 'show', :id => @document
  		else
  			flash[:failure] = "Votre commentaire n'a pas été ajouté"
  		end
    else
    	@review.rating = 3
      if request.format === Mime::JSON
        render :json => @document
      end
        # render :action => :show, :format => params[:format], :layout => (params[:format] == "json" ? false : 'documents')
  	end
  end

  def edit
    @document = current_user.documents.find(params[:id])
    if request.post?
      if @document.update_attributes(params[:document])
        flash[:success] = "Votre document a bien été édité"
        redirect_to :action => 'show', :id => @document
      else
        flash[:failure] = "Votre document n'a pas été édité"
      end
    end
  end

	def manage
		@documents = current_user.documents.paginate :page => params[:page], :per_page => 10
	end

  def upload
  	@document = current_user.documents.find(params[:id])
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
				upload_file = (params[:document] and params[:document][:file])
			end

			begin
				logger.debug "Upload file: #{upload_file.inspect}"
				uploaded = @document.upload_file(upload_file)
			rescue Exception => e
 				logger.error("Can't upload #{upload_file.to_s}: #{e} #{e.backtrace}")
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
  	@document = current_user.documents.find(params[:id])
  	send_file @document.path, :type => @document.format, :filename => @document.filename
  end

  def destroy
    current_user.documents.find(params[:id]).destroy
    flash[:success] = "Votre document a bien été détruit"
    redirect_to :action => 'manage'
  end

  def publish
  	@document = current_user.documents.find(params[:id])
	  flash[:warning] = "Votre document n'est lié à aucun fichier" unless @document.uploaded?
	end

  def share
  	@document = current_user.documents.find(params[:id])
	  flash[:warning] = "Votre document n'est lié à aucun fichier" unless @document.uploaded?
	end

	def tag
		@documents = current_user.documents.find_by_tag(params[:name]).paginate(:page => params[:page], :per_page => 4)
	end

	def auto_complete_for_tags
    query = params[:q].downcase

    tags = Tag.where(["name like ?", "%#{query}%"]).order(:name)
    tags.unshift Tag.new(:name => query) unless tags.any? { |t| t.name == query }

    render :json => tags
	end

  def listen
  	@document = current_user.documents.find(params[:id])
    cast = @document.casts.first

    expectedo_token = cast.expected_token(request.ip)

  	redirect_to controller: 'casts', action: 'play', name: cast.name, token: cast.expected_token(request.ip), format: params[:format]
	end

  def auto_complete_for_subscribers
  	document = current_user.documents.find(params[:id])
    query = params[:q].downcase

    candidates = document.nonsubscribers.select do |people|
      people.match_name?(query)
    end

    render :json => tokenize_subscribers(candidates)
  end

  protected

  def tokenize_subscribers(candidates)
    candidates.map do |candidate|
      name = candidate.name

      case candidate
      when User
        name += " (#{candidate.organization})" if candidate.organization.present?
      when Group
        name += " (Groupe)"
      end

      { :id => "#{candidate.class.name.downcase}:#{candidate.id}",
        :name => name }
    end
  end
  helper_method :tokenize_subscribers

end
