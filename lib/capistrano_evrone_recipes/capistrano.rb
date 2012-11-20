require 'logger'
require File.dirname(__FILE__) + "/util"

Capistrano::Configuration.instance(:must_exist).load do
  default_run_options[:pty]   = true
  ssh_options[:forward_agent] = true

  recipes_dir = File.dirname(File.expand_path(__FILE__))

  set :bundle_cmd, "rbenv exec bundle"

  load "deploy"
  require 'bundler/capistrano'
  load "#{recipes_dir}/recipes/crontab.rb"
  load "#{recipes_dir}/recipes/foreman.rb"
  load "#{recipes_dir}/recipes/deploy.rb"
  load "#{recipes_dir}/recipes/login.rb"
  load "#{recipes_dir}/recipes/migrate.rb"
  load "#{recipes_dir}/recipes/rails.rb"
  load "#{recipes_dir}/recipes/unicorn.rb"
  load "#{recipes_dir}/recipes/silent.rb" if ENV['CAP_SILENT']
end
