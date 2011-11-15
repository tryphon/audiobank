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
