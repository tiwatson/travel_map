#!/home/watsonswander/.rvm/rubies/ruby-1.9.3-p327/bin/ruby

ENV['RAILS_ENV'] ||= 'production'
ENV['HOME'] ||= `echo ~`.strip
ENV['GEM_HOME'] = File.expand_path('~/.rvm/gems/ruby-1.9.3-p327')
ENV['GEM_PATH'] = File.expand_path('~/.rvm/gems/ruby-1.9.3-p327') + ":" +
    File.expand_path('~/.rvm/gems/ruby-1.9.3-p327@travelmap')

require 'fcgi' 
require File.join(File.dirname(__FILE__), '../config/environment')

class Rack::PathInfoRewriter
 def initialize(app)
   @app = app
 end

 def call(env)
   env.delete('SCRIPT_NAME')
   parts = env['REQUEST_URI'].split('?')
   env['PATH_INFO'] = parts[0]
   env['QUERY_STRING'] = parts[1].to_s
   @app.call(env)
 end
end