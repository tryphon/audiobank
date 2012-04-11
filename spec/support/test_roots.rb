Spec::Runner.configure do |config|
  config.before(:each) do
    TestRootSupport.all(:before, Document, Upload, Cast)
  end
  config.after(:each) do
    TestRootSupport.all(:after)
  end
end
