class Upload < ActiveRecord::Base
	belongs_to :document

	def to_s
    "Upload: #{@key} (#{path}, #{candidates})"
  end
  
  def create_key
		self.key = StringRandom.alphanumeric(16).downcase
  end

  before_create :create_key

  def create_path
		FileUtils.mkdir_p path
    # File.chmod tests if path is a String
    File.chmod 02775, path.to_s
  end

  before_create :create_path
  
	def destroy_path
		FileUtils.remove_dir(path) if File.exists?(path)
	end

  after_destroy :destroy_path

  @@root = Rails.root + "media/upload"
  cattr_accessor :root

  def self.test_root
    Rails.root + "tmp/upload"
  end
	
	def path 
    root + key
	end
	
	def candidates
		Dir.glob("#{path}/*")
	end
	
	def file
		File.new(candidates.first)
	end
	
	def public_url 
		"ftp://audiobank.tryphon.org/#{key}/"
	end
	
	def empty?
		candidates.empty?
	end

end
