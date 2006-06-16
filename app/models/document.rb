class Document < ActiveRecord::Base
	belongs_to :author
	has_many :subscribers, :through => :subscriptions
  has_many :subscriptions, :dependent => :destroy
	
	validates_presence_of :title, :message => "Un titre est requis"
	validates_presence_of :description, :message => "Une description est requise"
	
	def filename
		id # find a standard and smarter way to name the file (based on document id)
	end
	
	def file=(file) # should calculate time length and return false if copy fail
		format = file.content_type # should be used in a smarter way (check, format and save)
		File.open("#{RAILS_ROOT}/media/#{filename}", "wb") do |f| 
    	f.write(file.read)
    end
    size = File.size("#{RAILS_ROOT}/media/#{filename}")
	end
	
	def after_destroy
    File.delete("#{RAILS_ROOT}/media/#{filename}") if File.exist?("#{RAILS_ROOT}/media/#{filename}")
  end
end
