namespace :sphinx do
  desc "Sphinx rebuild"
  task :rebuild, :roles => :sphinx, :on_no_matching_servers => :continue, :except => { :no_release => true }  do
    run("cd #{current_path} && bundle exec rake ts:rebuild RAILS_ENV=#{rails_env}")
  end
end
