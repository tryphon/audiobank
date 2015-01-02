class CastsController < ApplicationController
	layout :nil

  skip_before_filter :check_authentication

  def play
    format = params[:format]
    name = params[:name]

  	@cast = Cast.includes(:document).find_by_name!(name)
    @document = @cast.document

  	case format
  	when "mp3", "ogg"
  		playcontent @cast, format
  	when "m3u"
  		render text: playlist(@cast), type: "audio/x-mpegurl"
    when "json"
      render json: { title: @document.title, author: @document.author.name, duration: @document.duration, tags: @document.tags.map(&:name) }
  	else
      render
  	end
  end

  private

  def playcontent(cast, format)
    if expected_token = cast.expected_token(request.ip)
      unless expected_token.validate(params[:token])
        logger.info "Refuse Cast #{cast.name} access (expected: '#{expected_token}')"
        render status: 403, text: "Invalid token"
        return
      end
    end

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
    query = "?token=#{params[:token]}" if params[:token]
  	content += url_for(:action => 'play', :name => cast.name) + ".mp3#{query}\n"
  end
end
