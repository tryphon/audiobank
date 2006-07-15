class CastsController < ApplicationController
	layout 'documents', :except => [:play,:playlist]

  def play
  	if params[:content]
  		playcontent
  	else 
  		playlist 
  	end
  end
  
  def playcontent
  	@cast = Cast.find_by_name(params[:name])
  	send_file @cast.path, :type => "application/ogg", :filename => "audiobank-#{@cast.name}.ogg"
  end

  def playlist
  	@cast = Cast.find_by_name(params[:name])
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cast.document.length},#{@cast.document.title}\n" 
  	content += url_for(:action => 'play', :name => @cast.name, :content => 'true') + "\n"
		render :text => content, :content_type => 'audio/x-mpegurl'
  end

end
