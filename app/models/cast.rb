class Cast < ActiveRecord::Base
	belongs_to :document

  validates_presence_of :name
  validates_uniqueness_of :name

  # FIXME
  attr_accessible :name, :document

	FORMATS = %w(ogg mp3)

  def self.each_format(&block)
    FORMATS.each &block
  end
  def each_format(&block)
    FORMATS.each &block
  end

	def update_file(format = "ogg")
		# puts "DEBUG: #{Rails.root}/bin/encode #{document.path} #{path(format)} #{format}"
		system "#{Rails.root}/bin/encode", document.path.to_s, path(format), format
	end

  def sox(*arguments)
    command = Array(arguments).flatten.join(' ')
    system "sox #{command} 2> /dev/null" or raise "Sox command failed : 'sox #{command}'"
  end

  def sox_task(description, *arguments)
    sox_duration = Benchmark.ms do
      sox *arguments
    end
    Rails.logger.info "Created document #{document.id} #{description} in #{sox_duration.to_i}s"
  end

  @@temp_directory = Dir.tmpdir
  cattr_accessor :temp_directory

  def prepare!
    return if uptodate?

    Tempfile.open([name, '.wav'], temp_directory) do |wav_file|
      sox_task "wav", "-t", document.extname, document.path, wav_file.path
      FORMATS.each do |format|
        unless uptodate? format
          quality = (format == "mp3" ? "-3.2" : 5)
          sox_task format, wav_file.path, "-C", quality, path(format)
        end
      end
    end

    touch
  end

  def prepare
    begin
      prepare!
    rescue => e
      Rails.logger.error "Can't prepare Cast #{id} : #{e}"
    end
  end

	def before_destroy
		FORMATS.each do |format|
			File.delete(path(format)) if File.exists?(path(format))
		end
	end

  @@root = Rails.root + "media/casts"
  cattr_accessor :root

	def path(format = "ogg")
	  "#{root}/#{filename(format)}"
	end

	def filename(format = "ogg")
	  "#{id}.#{format}"
	end

	def public_filename(format = "ogg")
	  "#{document.title}.#{format}"
	end

	def size(format = "ogg")
	  File.exists?(path(format)) ? File.size(path(format)) : 0
	end

  def mime_type(format = "ogg")
  	case format
    when "mp3" then "audio/mpeg"
    when "ogg" then "audio/ogg"
    else nil
  	end
  end

	def uptodate?(format = nil)
    if format
		  FileUtils.uptodate?(path(format), [document.path])
    else
      FORMATS.all? { |format| uptodate?(format) }
    end
	end

  def self.prepare
		Cast.includes(:document).find_each(&:prepare)
    Document.to_be_prepared.find_each(&:prepare)
  end

	def self.update
		Cast.find(:all).each do |cast|
			FORMATS.each do |format|
				unless cast.uptodate?(format)
					puts "INFO: update #{format} cast for document #{cast.document.id}"
					if !cast.update_file(format) then
						puts "ERROR: can't update #{format} cast for document #{cast.document.id}"
					end
				end
			end
		end

		Document.to_be_prepared.each do |document|
      puts "INFO: create cast for document #{document.id}"
      cast = Cast.create(:document => document, :name => StringRandom.alphanumeric(8).downcase)

      FORMATS.each do |format|
        if !cast.update_file(format) then
          puts "ERROR: can't create cast for document #{document.id}"
        end
      end

      if FORMATS.all? { |f| cast.uptodate? f }
        document.casts << cast
        document.ready!
      else
        cast.destroy
      end
		end
	end

  def protected?
    document.protected_casts?
  end

  def expected_token(target)
    AccessToken.new(secret: document.author.casts_token_secret, target: target) if protected?
  end

  def validate_token(token, target)
    expected_token.validate(token)
  end

  def player_css_url
    document.author.player_css_url
  end

  def as_json(options = nil)
    {
      title: document.title,
      author: document.author.name,
      duration: document.duration,
      protected: document.protected_casts?,
      tags: document.tags.map(&:name),
      player_css_url: player_css_url,
      formats: {}
    }.tap do |attributes|
      each_format do |format|
        attributes[:formats][format] = {
          size: size(format)
        }
      end
    end
  end

end
