def test_sound_file(format = :ogg)
  File.join fixture_path, "one-second.#{format}"
end
