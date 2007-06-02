class Upload < ActiveRecord::Base
	belongs_to :document

	def to_s
    "Upload: #{@key} (#{path}, #{candidates})"
  end
  
  def before_create
		self.key = StringRandom.alphanumeric(16).downcase

		FileUtils.mkdir_p path
		File.chmod(02775, path)
  end
  
	def after_destroy
		FileUtils.remove_dir(path) if File.exists?(path)
	end
	
	def path 
		"#{RAILS_ROOT}/media/upload/#{key}"
	end
	
	def candidates
		Dir.glob("#{path}/*")
	end
	
	def file
		File.new(candidates.first)
	end
	
	def public_url 
		"ftp://audiobank.tryphon.org/upload/media/#{key}/"
	end
	
	def empty?
		candidates.empty?
	end

end
