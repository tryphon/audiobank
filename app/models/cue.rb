class Cue < ActiveRecord::Base
	belongs_to :document
	
	def update_file
		puts "DEBUG: create cue #{path} with #{document.path}"
		system "#{RAILS_ROOT}/bin/cueenc", document.path, path
	end

	def path
		"#{RAILS_ROOT}/media/cue/#{id}"
	end
	
	def self.update
		Document.find(:all).delete_if { |d| !d.uploaded? or !d.cues.empty? }.each do |document|
			puts "INFO: create cue for #{document.id}"
			cue = Cue.create(:document => document)
			if !cue.update_file then
				puts "ERROR: can't create cue for #{document.id}"
				cue.destroy 
			end
		end		
	end
	
end
