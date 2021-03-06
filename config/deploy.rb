require "bundler/capistrano"

set :application, 'retaste.me'

role :app, "retaste.me"
role :web, "retaste.me"
role :db,  "retaste.me", :primary => true
set :deploy_to, "/mnt/app/#{application}"

set :user, "www-data"
set :group, "www-data"
set :use_sudo, false
set :keep_releases, 5

set :rails_env, 'production'

# Source code
set :scm, :git
set :repository, "git@github.com:martincik/retaste.me.git"
set :branch, "master"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

default_run_options[:pty] = true

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

task :copy_database_yml do
  run "cp #{shared_path}/config/database.yml #{release_path}/config"
end
after "deploy:update_code", :copy_database_yml

namespace :deploy do
  desc "Restarting mod_rails with restart.txt."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails."
    task t, :roles => :app do ; end
  end
end

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end
end
after "deploy:symlink", "deploy:update_crontab"

task :link_data_directory do
  run "ln -s #{shared_path}/data #{release_path}/data"
end
after "deploy:symlink", :link_data_directory
