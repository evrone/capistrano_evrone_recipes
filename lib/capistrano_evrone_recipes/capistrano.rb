require File.dirname(__FILE__) + "/util"

Capistrano::Configuration.instance(:must_exist).load do
  default_run_options[:pty]   = true
  ssh_options[:forward_agent] = true

  set :default_environment, {
    'RBENV_ROOT' => '/usr/local/rbenv',
    'PATH'       => "/usr/local/rbenv/shims:$PATH"
  }

  recipes_dir = File.dirname(File.expand_path(__FILE__))

  load "deploy"
  require 'bundler/capistrano'
  load "#{recipes_dir}/recipes/crontab.rb"
  load "#{recipes_dir}/recipes/deploy.rb"
end
