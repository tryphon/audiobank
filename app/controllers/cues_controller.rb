class CuesController < ApplicationController
	layout nil

  def playlist
  	@cue = Cue.find(params[:id])
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cue.document.length},#{@cue.document.title}\n" 
  	content += url_for(:action => 'play', :id => @cue.id) + "\n"
		render :text => content, :content_type => 'audio/x-mpegurl'
  end
  
  def play
  	@cue = Cue.find(params[:id])
  	send_file @cue.path, :type => "application/ogg", :filename => "audiobank-#{@cue.id}.ogg"
  end
end
