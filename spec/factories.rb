require 'string_random'

Factory.define :audio_document do |d|
  d.title "title"
  d.description "description"
  d.association :author, :factory => :user
end

Factory.define :document, :class => "AudioDocument" do |d|
  d.title "title"
  d.description "description"
  d.association :author, :factory => :user
end

Factory.define :user do |u|
  u.name "name"
  u.sequence(:username) { |n| "username-#{n}" }
  u.email "dummy@tryphon.org"
  u.password "password"
  u.confirmed true
end

Factory.define :group do |f|
  f.sequence(:name) { |n| "Group #{n}"}
  f.sequence(:description) { |n| "Test Group #{n}"}
  f.association :owner, :factory => :user
end

Factory.define :subscription do |s|
  s.association :subscriber, :factory => :user
end

Factory.define :review do |r|
  r.rating 3
  r.description "description"
  r.association :user, :factory => :user
end

Factory.define :tag do |t|
  t.sequence(:name) { |n| "tag_#{n}" }
end

Factory.define :cast do |d|
  d.association :document
  d.name StringRandom.alphanumeric(8).downcase
end

Factory.define :dropbox do |d|
  d.association :user
  d.sequence(:login) { |n| "login-#{n}" }
  d.password StringRandom.alphanumeric(8)
  d.sequence(:directory) { |n| "dropbox-#{n}" }
end
