Given(/^a document exists for current user$/) do
  create_model("a document").tap do |document|
    # Use current_user as author
    document.update_attribute :author, @current_user if @current_user
  end
end

Given /^I upload the file "([^"]*)\" to the specified ftp url$/ do |file|
  upload_key = page.body.scan(%r{#{Upload.ftp_server}/([a-z0-9]+)/}).uniq.flatten.first
  FileUtils.cp file, Upload.find_by_key(upload_key).path
end
