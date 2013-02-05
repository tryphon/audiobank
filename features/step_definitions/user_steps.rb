Given(/^a confirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: true")
end

Given(/^an unconfirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: false")
end

Given /^I am a new, authenticated user$/ do
  @current_user = create_model('an user "current user"', :password => "secret", :confirmed => true)
  visit('/signin')

  step %{I fill in "user_username" with "#{@current_user.username}"}
  step %{I fill in "user_password" with "secret"}
  step %{I press "Se connecter"}
end
