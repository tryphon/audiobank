Spec::Runner.configure do |config|
  config.before(:each) do
    Document.test_root.mkpath
    Document.root = Document.test_root
  end
  config.after(:each) do
    Document.test_root.rmtree
  end
end
