Before do
  Document.test_root.mkpath
  Document.root = Document.test_root
end

After do
  Document.test_root.rmtree
end
