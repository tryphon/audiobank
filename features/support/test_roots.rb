Before do
  TestRootSupport.all(:before, Document, Upload)
end

After do
  TestRootSupport.all(:after)
end
