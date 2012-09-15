$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'
set :application, "library_schedule"
set :repository,  "git@git.fsd.domain:robinson-sandbox/library_schedule.git"

default_run_options[:pty] = true

set :use_sudo, false

set :scm, :git

set :user, "deploy"
set :group, "www-data"
set :rvm_bin_path, "/usr/local/rvm/bin/"
set :rvm_path, "/usr/local/rvm/"

#ssh_options[:forward_agent] = true
set :branch, "master"
#set :deploy_via, :remote_cache

set :deploy_to, "/var/rails_apps/library_schedule"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "10.205.50.168"                          # Your HTTP server, Apache/etc
role :app, "10.205.50.168"                          # This may be the same as your `Web` server
role :db,  "10.205.50.168", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

   task :symlink_shared do
     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
   end
 end

after 'deploy:update_code', 'deploy:symlink_shared'