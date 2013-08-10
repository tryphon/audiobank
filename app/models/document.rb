require 'mahoro'
require 'tagfile'
require 'taglib_ext'

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

  def self.to_be_prepared
    includes(:casts).where( :uploaded => true, :casts => { :document_id=> nil } )
  end

  attr_accessible :description, :title, :subscriber_tokens
  # FIXME
  attr_accessible :subscriber

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
    length
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

  def delete_file
		File.delete(path) if File.exist?(path)
  end

	after_destroy :delete_file

  delegate :destroy_orphelan_tags, :to => Tag

  after_destroy :destroy_orphelan_tags
  after_save :destroy_orphelan_tags


	before_create :build_upload

  attr_accessible :tag_tokens
  attr_reader :tag_tokens

  def tag_tokens=(tokens)
  	Tag.transaction do
  		self.tags = Tag.parse(tokens)
  	end
  end

  attr_reader :subscriber_tokens
  def subscriber_tokens=(tokens)
    self.subscriptions = tokens.split(",").map do |token|
      subscriber_type, subscriber_id = token.split(':')
      subscriptions.where(:subscriber_id => subscriber_id, :subscriber_type => subscriber_type.classify).first_or_create(:author => author)
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
    UserMailer.document_ready(self).deliver

    hooks.each do |hook|
      hook.document_ready self
    end

    true
  end

end
