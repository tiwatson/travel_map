require "bundler/capistrano"

set :shell, '/bin/bash'
set :default_environment, { 'PATH' => "/home/watsonswander/.rvm/gems/ruby-1.9.3-p327/bin:/home/watsonswander/.rvm/gems/ruby-1.9.3-p327@global/bin:/home/watsonswander/.rvm/rubies/ruby-1.9.3-p327/bin:/home/watsonswander/.rvm/bin:/home/watsonswander/.gems/bin:/usr/lib/ruby/gems/1.8/bin/:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/home/watsonswander/.rvm/gems/ruby-1.9.3-p327@global/bin/bundle" }
set :application, "travel_map"
set :scm, :git
set :repository,  "git@github.com:tiwatson/travel_map.git"

set :user, "watsonswander"
set :use_sudo, false
server "watsonswander.com", :app, :web, :db, :primary => true
set :deploy_to, "/home/watsonswander/travelmap.tiwatson.com/"

namespace :deploy do
  after "deploy:update_code", :link_production_db
end

# database.yml task
desc "Link in the database.yml"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

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