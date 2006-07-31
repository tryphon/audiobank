class CastsController < ApplicationController
	layout nil

  def play
  	extension = params[:name].split('.').last
  	case extension
  		when "ogg":
  			playcontent(File.basename(params[:name], "."+ extension))
  		when "m3u" 
  			playlist(File.basename(params[:name], "."+ extension))
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
   
  def playcontent(name)
  	@cast = Cast.find_by_name(name)
  	send_file @cast.path, :type => "application/ogg", :filename => "audiobank-#{@cast.name}.ogg", :disposition => "inline"
  end

  def playlist(name)
  	@cast = Cast.find_by_name(name)

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
