require "bundler/capistrano"

set :default_environment, { 'PATH' => '$PATH:/usr/lib/ruby/gems/1.8/bin//bundle' }
set :application, "travel_map"
set :scm, :git
set :repository,  "git@github.com:tiwatson/travel_map.git"

set :user, "watsonswander"
set :use_sudo, false
server "watsonswander.com", :app, :web, :db, :primary => true
set :deploy_to, "/home/watsonswander/travelmap.tiwatson.com/"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end