Given(/^a document exists$/) do
  create_model("a document").tap do |document|
    # Use current_user as author
    document.update_attribute :author, @current_user if @current_user
  end
end
