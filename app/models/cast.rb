class Cast < ActiveRecord::Base
	belongs_to :document
	
	def update_file
		system "#{RAILS_ROOT}/bin/cueenc", document.path, path
	end
	
	def before_destroy
		File.delete(path) if File.exists?(path)
	end

	def path
		"#{RAILS_ROOT}/media/cast/#{id}"
	end
	
	def self.update
		Document.find(:all).delete_if { |d| !d.uploaded? or !d.casts.empty? }.each do |document|
			puts "INFO: create cast for document #{document.id}"
			cast = Cast.create(:document => document, :name => String.random_alphanumeric(8).downcase)
			if !cast.update_file then
				puts "ERROR: can't create cast for document #{document.id}"
				cast.destroy
			end
		end		
	end
	
end

def String.random_alphanumeric(size=16)
  s = ""
  size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  s
end
