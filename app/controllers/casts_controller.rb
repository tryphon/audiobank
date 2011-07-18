class CastsController < ApplicationController
	layout nil

  def play
  	case params[:format]
  		when "mp3":
  			playcontent(File.basename(params[:name], "."+ params[:format]), params[:format])
  		when "ogg":
  			if mp3_only_player?
			  	real_name = File.basename(params[:name], "."+ params[:format])
	  			redirect_to :action => :play, :name => real_name +".mp3"  
	  			return
	  		end
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

  	case format
  		when "ogg":
  			type = "application/ogg"
  		when "mp3" 
  			type = "application/mp3"
  	end
  	redirect_to "/static/cast/#{@cast.filename(format)}"
  end

  def playlist(name)
  	@cast = Cast.find_by_name(name)
    raise ActiveRecord::RecordNotFound unless @cast

  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cast.document.length},#{@cast.document.title}\n" 
  	content += url_for(:action => 'play', :name => @cast.name) + ".ogg\n"

		m3u_url = "cache/#{name}.m3u"
		m3u_path = "#{RAILS_ROOT}/public/#{m3u_url}"
		unless File.exists?(m3u_path)
			File.open(m3u_path, "w") do |f|
					f.write(content)
			end
		end

  	redirect_to "/#{m3u_url}"
  end
end
