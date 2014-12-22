def test_sound_file(format = :ogg)
  File.join fixture_path, "one-second.#{format}"
end


class Document
  def upload_fixture
    upload_file(File.new(test_sound_file)) && save
  end
end

class Cast
  def prepare_fixture
    Cast.each_format do |format|
      FileUtils.cp test_sound_file, path(format)
    end
  end
end
