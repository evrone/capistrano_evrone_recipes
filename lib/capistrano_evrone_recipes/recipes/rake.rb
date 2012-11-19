namespace :rake do
  desc "Run a task on a remote server."
  task :invoke, :roles => :db, :on_no_matching_servers => :continue, :only => {:primary => true}  do
    run("cd #{current_path} && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end
