require 'tagfile'

module TagFile
	class File

    @@types_from_mime = {
      "application/ogg" => TagFile::OggVorbis,
      "audio/mpeg" => TagFile::MPEG,
      "audio/x-flac" => TagFile::FLAC
    }
    cattr_accessor :types_from_mime

    def self.type_from_mime(mime_type)
      types_from_mime[mime_type]
    end

    def self.with_mime_type(path, mime_type)
      file_type = type_from_mime(mime_type)
      new path, file_type
    end

  end
end
