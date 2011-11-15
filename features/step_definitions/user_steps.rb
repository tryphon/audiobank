Given(/^a confirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: true")
end

Given(/^an unconfirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: false")
end

Given /^I am a new, authenticated user$/ do
  @current_user = create_model('an user "current user"', :password => "secret", :confirmed => true)
  visit('/signin')
  And %{I fill in "user_username" with "#{@current_user.username}"}
  And %{I fill in "user_password" with "secret"}
  And %{I press "Se connecter"}
end
