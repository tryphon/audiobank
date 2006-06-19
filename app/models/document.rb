require 'taglib'
class Document < ActiveRecord::Base
	belongs_to :author
	has_many :subscribers, :through => :subscriptions
	has_many :subscriptions, :dependent => :destroy
	
	validates_presence_of :title, :message => "Un titre est requis"
	validates_presence_of :description, :message => "Une description est requise"
	
	attr_protected :size, :length, :format, :file
	
	def filename
		"#{id}#{suffix}"
	end
	
	def path
		"#{RAILS_ROOT}/media/#{filename}"
	end
	
	def duration
		Time.at(self.length) - 3600
	end
	
	def file=(file) # should calculate time length and return false if copy fail
		self.format = file.content_type.chomp
		self.size = file.length
		File.open(path, "wb") do |f| 
    	f.write(file.read)
    end
    file = TagLib::File.new(path)
    self.length = file.length
    file.close
 		self.uploaded = true
  end
	
	def after_destroy
    File.delete(path) if File.exist?(path)
  end
  
  def uploaded?
  	uploaded
  end

	protected
  def suffix
  	case self.format
  		when "audio/mpeg" then ".mp3"
  		when "audio/x-flac" then ".flac"
  		when "application/ogg", "audio/x-vorbis+ogg" then ".ogg"
  		# not supported format :
  		when "audio/x-wav" then ".wav"
  		when "audio/mp4" then ".ma4"
  		else nil
  	end
  end
end
