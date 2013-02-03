class CastsController < ApplicationController
	layout nil

  def play
  	case params[:format]
  		when "mp3":
  			playcontent(File.basename(params[:name], "."+ params[:format]), params[:format])
  		when "ogg":
  			playcontent(File.basename(params[:name], "."+ params[:format]), params[:format])
  		when "m3u" 
  			playlist(File.basename(params[:name], "."+ params[:format]))
  		else
  			redirect_to :action => :play, :name => params[:name]+".m3u"
  	end
  end
  
  private
  def player?
  	if request.env['HTTP_USER_AGENT'] =~ /^Winamp|Windows/
  		true
  	else
  		false
  	end
  end

  def mp3_only_player?
  	if request.env['HTTP_USER_AGENT'] =~ /^Windows|mpg321|RMA|iTunes/
  		true
  	else
  		false
  	end
  end
   
  def playcontent(name, format)
  	@cast = Cast.find_by_name(name)
    raise ActiveRecord::RecordNotFound unless @cast

    unless request.head?
      @cast.increment(:download_count).save
      logger.info "Play Cast #{@cast.name} #{format} #{@cast.size(format)} #{@cast.download_count} #{@cast.document.id} #{@cast.document.author.username} \"#{@cast.document.title}\""
    end

  	redirect_to "/static/cast/#{@cast.filename(format)}"
  end

  def playlist(name)
  	@cast = Cast.find_by_name(name)
    raise ActiveRecord::RecordNotFound unless @cast

  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cast.document.length},#{@cast.document.title}\n" 
  	content += url_for(:action => 'play', :name => @cast.name) + ".mp3\n"

		m3u_url = "cache/#{name}.m3u"
		m3u_path = "#{Rails.root}/public/#{m3u_url}"
		unless File.exists?(m3u_path)
			File.open(m3u_path, "w") do |f|
					f.write(content)
			end
		end

  	redirect_to "/#{m3u_url}"
  end
end
