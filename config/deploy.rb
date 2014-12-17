set :application, "audiobank"
set :scm, "git"
set :repository, "git://projects.tryphon.priv/audiobank"

set :deploy_to, "/var/www/audiobank"

set :keep_releases, 5
after "deploy:update", "deploy:cleanup"
set :use_sudo, false
default_run_options[:pty] = true

set :bundle_cmd, "/var/lib/gems/1.9.1/bin/bundle"
set :rake, "#{bundle_cmd} exec rake"

server "radio.dbx1.tryphon.priv", :app, :web, :db, :primary => true
# server "sandbox", :app, :web, :db, :primary => true

after "deploy:update_code", "deploy:symlink_shared", "deploy:bundle_link"

require "bundler/capistrano"
load "deploy/assets"

namespace :deploy do
  # Prevent errors when chmod isn't allowed by server
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')} && (chmod g+w #{dirs.join(' ')} || true)"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :bundle_link do
    run "ln -fs #{bundle_cmd} #{release_path}/script/bundle"
  end

  desc "Symlinks shared configs and folders on each release"
  task :symlink_shared, :except => { :no_release => true }  do
    run "ln -nfs #{shared_path}/config/database.yml #{shared_path}/config/newrelic.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/"

    run "ln -nfs #{shared_path}/media #{release_path}/media"
    sudo "ln -nfs #{shared_path}/casts #{release_path}/media/casts"
    sudo "ln -nfs #{shared_path}/upload #{release_path}/media/upload"
    run "ln -nfs #{shared_path}/playlists #{release_path}/public/cache"

    # FIXME remove media/cast
    sudo "ln -nfs #{shared_path}/casts #{release_path}/media/cast"
  end
end
