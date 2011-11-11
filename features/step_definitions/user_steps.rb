Given(/^a confirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: true")
end

Given(/^an unconfirmed user exists with #{capture_fields}$/) do |fields|
  create_model("a user", fields << ", confirmed: false")
end

