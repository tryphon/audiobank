class CastsController < ApplicationController
	layout nil

  def play
  	name = File.basename(params[:name], ".ogg")
  	if params[:name] != name
  		playcontent(name)
  	else 
  		playlist(params[:name])
  	end
  end
  
  private
  def playcontent(name)
  	@cast = Cast.find_by_name(name)
  	send_file @cast.path, :type => "application/ogg", :filename => "audiobank-#{@cast.name}.ogg", :disposition => "inline"
  end

  def playlist(name)
  	@cast = Cast.find_by_name(name)
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cast.document.length},#{@cast.document.title}\n" 
  	content += url_for(:action => 'play', :name => @cast.name) + ".ogg\n"
		render :text => content, :content_type => 'audio/x-mpegurl'
  end
end
