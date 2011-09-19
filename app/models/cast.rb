class Cast < ActiveRecord::Base
	belongs_to :document

	FORMATS = %w(ogg mp3)

	def update_file(format = "ogg")
		puts "DEBUG: #{RAILS_ROOT}/bin/encode #{document.path} #{path(format)} #{format}"
		system "#{RAILS_ROOT}/bin/encode", document.path, path(format), format
	end

	def before_destroy
		FORMATS.each do |format|
			File.delete(path(format)) if File.exists?(path(format))
		end
	end

	def path(format = "ogg")
	  "#{RAILS_ROOT}/media/cast/#{filename(format)}"
	end

	def filename(format = "ogg")
	  "#{id}.#{format}"
	end

	def size(format = "ogg")
	  File.exists?(path(format)) ? File.size(path(format)) : 0
	end

	def uptodate?(format = "ogg")
		FileUtils.uptodate?(path(format), document.path)
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
        Mailer::deliver_document_ready(document)
      else
        cast.destroy
      end
		end
	end
end
