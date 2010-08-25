require 'taglib'
module TagLib
	class File
    def taglibForMime(mime)
      puts mime
      if mime.include?('MP3') or mime.match(/MPEG.*layer III/)
        return TagLib::MPEG
      end

      if mime.include?('Ogg') or mime.include?('ogg')
        if mime.include?('Vorbis') or mime.include?('vorbis')
          return TagLib::OggVorbis
        end
      end

      if mime.include?('FLAC')
        return TagLib::FLAC
      end

      return nil
    end
  end
end
