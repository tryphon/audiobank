desc "Analyzes code to find security issues"
task :brakeman do
  sh "bundle exec brakeman --no-progress --confidence-level=3 --message-limit=-1 --exit-on-warn"
end
