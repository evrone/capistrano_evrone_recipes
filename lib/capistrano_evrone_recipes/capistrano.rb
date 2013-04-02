require 'logger'
require File.dirname(__FILE__) + "/util"

Capistrano::Configuration.instance(:must_exist).load do
  logger.level = Capistrano::Logger::INFO

  default_run_options[:pty]   = true
  ssh_options[:forward_agent] = true

  set :bundle_cmd,                 "rbenv exec bundle"
  set :bundle_flags,               "--deployment --quiet"
  set :rake,                       -> { "#{bundle_cmd} exec rake" }
  set :keep_releases,              7
  set :scm,                        "git"
  set :user,                       "deploy"
  set :deploy_via,                 :unshared_remote_cache
  set :copy_exclude,               [".git"]
  set :repository_cache,           -> { "#{deploy_to}/shared/#{application}.git" }
  set :normalize_asset_timestamps, false
  set :use_sudo,                   false

  load "deploy"
  require 'bundler/capistrano'

  recipes_dir = File.dirname(File.expand_path(__FILE__))

  disabled_modules = fetch(:disabled_features, [])

  load "#{recipes_dir}/recipes/crontab.rb" unless disabled_modules.include?(:crontab)
  load "#{recipes_dir}/recipes/runit.rb"
  load "#{recipes_dir}/recipes/deploy.rb"
  load "#{recipes_dir}/recipes/login.rb"
  load "#{recipes_dir}/recipes/migrate.rb" unless disabled_modules.include?(:migrate)
  load "#{recipes_dir}/recipes/rails.rb"
  load "#{recipes_dir}/recipes/unicorn.rb" unless disabled_modules.include?(:unicorn)
  load "#{recipes_dir}/recipes/assets.rb"
  load "#{recipes_dir}/recipes/silent.rb" if ENV['CAP_SILENT_MODE']
end
