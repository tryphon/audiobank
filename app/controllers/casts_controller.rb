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
  		render text: playlist_content(@cast), type: "audio/x-mpegurl"
    when "json"
      render json: @cast
  	else
      render
  	end
  end

  def playlist
  	@cast = Cast.includes(:document).find_by_name!(params[:name])
  	render text: playlist_content(@cast, params[:prefered_format]), type: "audio/x-mpegurl"
  end

  private

  @@uuid_generator = UUID.new
  cattr_reader :uuid_generator

  def playcontent(cast, format)
    if expected_token = cast.expected_token(request.ip)
      unless expected_token.validate(params[:token])
        logger.info "Refuse Cast #{cast.name} access (expected: '#{expected_token}')"
        render status: 403, text: "Invalid token"
        return
      end
    end

    Download.from_request(request, cast, format) unless request.head?

    if request.get? and !request.params[:redirect] and CastServer.hotspot?(cast, format) and redirect_url = CastServer.redirect_url(request, cast, format)
      redirect_to redirect_url
    else
      expiration = 1.year
      expires_in expiration, public: false
      response.headers["Expires"] = expiration.from_now.httpdate

      send_file @cast.path(format), :type => @cast.mime_type(format), :filename => @cast.public_filename(format)
    end
  end

  def playlist_content(cast, prefered_format = "mp3")
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{cast.document.length},#{cast.document.title}\n"
    query = "?token=#{params[:token]}" if params[:token]
  	content += url_for(:action => 'play', :name => cast.name) + ".#{prefered_format}#{query}\n"
  end
end
