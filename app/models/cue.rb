class Cue < ActiveRecord::Base
	belongs_to :document
	
	def update_file(document)
		system "#{RAILS_ROOT}/bin/cueenc", document.path, path
	end

	def path
		"#{RAILS_ROOT}/media/cue/#{id}.ogg"
	end
	
end
