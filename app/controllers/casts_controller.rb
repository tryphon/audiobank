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

    unless request.head?
      cookie_name = "d/#{cast.name}"
      unless cookies[cookie_name]
        download_uuid = uuid_generator.generate
        cookie_deadline = Time.now + cast.document.duration

        logger.debug "Define cookie #{cookie_name} which expires on #{cookie_deadline}"
        cookies[cookie_name] = {
          :value => download_uuid,
          :expires => cookie_deadline
        }

        Cast.increment_counter(:download_count, cast.id)
        logger.info "Play Cast #{download_uuid} #{cast.name} #{format} #{cast.size(format)} #{cast.download_count} #{cast.document.id} #{cast.document.author.username} \"#{cast.document.title}\""
      end
    end

    expiration = 1.year
    expires_in expiration, public: false
    response.headers["Expires"] = expiration.from_now.httpdate

    send_file @cast.path(format), :type => @cast.mime_type(format), :filename => @cast.public_filename(format)
  end

  def playlist_content(cast, prefered_format = "mp3")
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{cast.document.length},#{cast.document.title}\n"
    query = "?token=#{params[:token]}" if params[:token]
  	content += url_for(:action => 'play', :name => cast.name) + ".#{prefered_format}#{query}\n"
  end
end
