class CastsController < ApplicationController
	layout nil

  skip_before_filter :check_authentication

  def play
    format = params[:format]
    name = params[:name]

  	@cast = Cast.includes(:document).find_by_name!(name)

  	case format
  	when "mp3", "ogg"
  		playcontent @cast, format
  	when "m3u"
  		render text: playlist(@cast), type: "audio/x-mpegurl"
    when "json"
      render json: { title: @cast.document.title, author: @cast.document.author.name, duration: @cast.document.duration, tags: @cast.document.tags.map(&:name) }
  	else
  		redirect_to :action => :play, :name => "#{name}.m3u"
  	end
  end

  private

  def playcontent(cast, format)
    unless request.head?
      Cast.increment_counter(:download_count, cast.id)
      logger.info "Play Cast #{cast.name} #{format} #{cast.size(format)} #{cast.download_count} #{cast.document.id} #{cast.document.author.username} \"#{cast.document.title}\""
    end

    expiration = 1.year
    expires_in expiration, public: true
    response.headers["Expires"] = expiration.from_now.httpdate

    send_file @cast.path(format), :type => @cast.mime_type(format), :filename => @cast.public_filename(format)
  end

  def playlist(cast)
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{cast.document.length},#{cast.document.title}\n"
  	content += url_for(:action => 'play', :name => cast.name) + ".mp3\n"
  end
end
