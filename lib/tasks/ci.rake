namespace :ci do
  desc "Prepare CI build"
  task :setup do
    cp "config/database.yml.sample", "config/database.yml"
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => ["ci:setup", "db:migrate", "spec", "spec:rcov", "cucumber"]
