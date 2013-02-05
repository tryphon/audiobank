class Cue < ActiveRecord::Base
	belongs_to :document
	
	def update_file
		system "#{Rails.root}/bin/encode", document.path, path, "ogg"
	end
	
	def before_destroy
		File.delete(path) if File.exists?(path)
	end

	def path
		"#{Rails.root}/media/cue/#{id}"
	end
	
	def self.update
		Document.find(:all).delete_if { |d| !d.uploaded? or !d.cues.empty? }.each do |document|
			puts "INFO: create cue for document #{document.id}"
			cue = Cue.create(:document => document)
			if !cue.update_file then
				puts "ERROR: can't create cue for document #{document.id}"
				cue.destroy 
			end
		end		
	end
	
end
