require 'mahoro'
require 'tagfile'

class Document < ActiveRecord::Base
	belongs_to :author, :class_name => "User", :foreign_key => "author_id"
	has_one :upload, :dependent => :destroy
	
	has_many :subscriptions, :dependent => :destroy
	has_many :cues, :dependent => :destroy
	has_many :reviews, :dependent => :destroy
	has_many :casts, :dependent => :destroy
	has_and_belongs_to_many :tags
	
	validates_presence_of :title, :message => "Un titre est requis"
	validates_presence_of :description, :message => "Une description est requise"
	validates_length_of :description, :maximum => 255, :message => "Votre description est trop longue", :allow_blank => true, :allow_nil => true
	
	attr_protected :size, :length, :format, :file
  
  named_scope :to_be_prepared, :include => "casts", :conditions => [ "uploaded and casts.id IS NULL" ]

	def subscribers
    # Subscription#subscriber is polymorphic
    # with current Rails, a has_many :through isn't possible
    self.subscriptions.collect { |s| s.subscriber }
  end
	
	def filename
		"#{id}-#{title}.#{extname}"
	end

  def extname
  	case self.format
    when "audio/mpeg" then "mp3"
    when "audio/x-flac" then "flac"
    when "application/ogg", "audio/x-vorbis+ogg" then "ogg"
  		# not supported format :
    when "audio/x-wav" then "wav"
    when "audio/mp4" then "ma4"
    else nil
  	end
  end

  @@root = Rails.root + "media"
  cattr_accessor :root
	
	def path
    root + id.to_s if id
	end

  def self.test_root
    Rails.root + "tmp/media"
  end
  
	def duration
    # TODO use a Duration object ?
		Time.at(self.length) + Time.local(1970,1,1).to_i
	end

  def download_count
    casts.sum :download_count
  end

  # Workaround for a strange error in DocumentsController#download : 
  # 'Attempt to call private method'
  def format
    read_attribute(:format)
  end

  def format=(format)
    write_attribute :format, format.gsub(/;.*$/, "")
  end
	
	def upload_file(file)
    self.format = Mahoro.new(Mahoro::MIME).file(file.path)

    document = TagFile::File.with_mime_type(file.path, format)
    self.length = document.length
    document.close
    
    file.respond_to?(:size) ? self.size = file.size : self.size = File.size(file.path)
    
    self.uploaded = false

    File.open(path, "wb") do |f|
      FileUtils.copy_stream(file, f)
    end
    
    self.uploaded = true
    self.cues.clear
    self.casts.clear
    
    true
	end
	
	def after_destroy
		File.delete(path) if File.exist?(path)
		Tag.destroy_orphelan_tags
  end
  
	def after_save
		Tag.destroy_orphelan_tags
	end
	
	def before_create
	  self.upload = Upload.new
	end
  
  def tag_with(list)
  	Tag.transaction do
  		self.tags = Tag.parse(list)
  	end
  end
  
  def nonsubscribers
    groups = Group.find(:all)
    users = User.find(:all, :conditions => ["id != ? AND confirmed = ?", author.id, true])
    return groups + users - subscribers
  end
  
  def match?(keywords)
    keywords = keywords.downcase.split(" ") if String === keywords

    keywords.all? do |keyword|
      [self.title, self.description, *self.tags].any? do |text|
        text = text.downcase if text.respond_to? :downcase
        text.match(keyword)
      end
    end
  end
  
  def match_tags?(tags)
    (Array(tags) - self.tags).empty?
  end

  def self.keywords(string)
    keywords = (string or "").downcase.split(" ")
    keywords.delete_if { |k| k.size < 3 }

    def keywords.to_s
      self.join(' ')
    end
    
    keywords
  end

  def to_json(options = {})
    { :id => id, 
      :title => title, 
      :length => length, 
      :description => description, 
      :download_count => download_count }.tap do |attributes|
      attributes[:cast] = casts.first.name unless casts.empty?
      attributes[:upload] = upload.public_url if upload
      attributes[:errors] = errors.to_json unless valid?
    end.to_json
  end

  @@hooks = []
  cattr_reader :hooks

  def ready!
    # Create a Hook for mails
    Mailer::deliver_document_ready self

    hooks.each do |hook|
      hook.document_ready self
    end

    true
  end

end
