class Upload 
	attr_reader :key

	def to_s
    "Upload: #{@key} (#{path}, #{candidates})"
  end
  
	def initialize(params=nil)
		if (params) 
			@key = params[:key]
		else 
			@key = StringRandom.alphanumeric(16).downcase
		end
	end

	def create
		Dir.mkdir path
		File.chmod(2775, path)
	end

	def delete
		FileUtils.remove_dir path
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
		"ftp://audiobank.tryphon.org/upload/media/#{key}"
	end
	
	def empty?
		candidates.empty?
	end

end
