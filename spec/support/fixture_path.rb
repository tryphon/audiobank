def fixture_path
  @fixture_path ||= File.join(File.dirname(__FILE__), "../fixtures")
end

class Document
  def upload_fixture
    upload_file(File.new(File.join(fixture_path, "one-second.ogg"))) && save
  end
end
