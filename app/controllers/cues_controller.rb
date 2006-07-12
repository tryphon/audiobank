class CuesController < ApplicationController
	layout 'documents', :except => [:play, :playlist]

  def playlist
  	@cue = Cue.find(params[:id])
  	content = "#EXTM3U\n"
  	content += "#EXTINF:#{@cue.document.length},#{@cue.document.title}\n" 
  	content += url_for(:action => 'play', :id => @cue.id)
		render :text => content, :content_type => 'audio/x-mpegurl'
  end
  
  def play
  	@cue = Cue.find(params[:id])
  	send_file @cue.path, :type => "ogg", :filename => "#{@cue.id}"
  end
end
