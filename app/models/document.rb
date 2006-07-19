require 'mahoro'
require 'taglib'
class Document < ActiveRecord::Base
	belongs_to :author
	belongs_to :upload
	has_many :subscribers, :through => :subscriptions
	has_many :subscriptions, :dependent => :destroy
	has_many :cues, :dependent => :destroy
	has_many :reviews, :dependent => :destroy
	has_many :casts, :dependent => :destroy
	has_and_belongs_to_many :tags
	
	validates_presence_of :title, :message => "Un titre est requis"
	validates_presence_of :description, :message => "Une description est requise"
	validates_length_of :description, :maximum => 255, :message => "Votre description est trop longue"
	
	attr_protected :size, :length, :format, :file
	
	def filename
		"#{id}-#{title}#{suffix}"
	end
	
	def path
		"#{RAILS_ROOT}/media/#{id}"
	end
		
	def duration
		Time.at(self.length) - 3600
	end
	
	def upload_file(file)
			document = TagLib::File.new(file.path, Mahoro.new(Mahoro::NONE).file(file.path))
				self.length = document.length
			document.close
			
			self.format = Mahoro.new(Mahoro::MIME).file(file.path)
			self.size = file.size
		
			File.open(path, "wb") do |f|
				f.write(file.read)
			end
 			
			self.uploaded = true
			self.cues.clear
			self.casts.clear
	end
	
	def after_destroy
		File.delete(path) if File.exist?(path)
		destroy_tags
  end
  
	def after_save
		destroy_tags
	end
  
  def uploaded?
  	uploaded
  end
  
  def tag_with(list)
  	Tag.transaction do
  		self.tags = Tag.parse(list)
  	end
  end
  
  def nonsubscribers
  	User.find(:all, :conditions => ["id != ? AND confirmed = ?", author.id, true]) - subscribers
  end

	protected	
	def destroy_tags
		Tag.find(:all, :include => :documents).each do |tag|
			tag.destroy if tag.documents.empty?
		end
	end
	
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
