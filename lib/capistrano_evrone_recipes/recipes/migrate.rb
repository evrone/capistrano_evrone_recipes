namespace :deploy do
  desc "Migrate database if has migration"
  task :migrate, :roles => :db, :on_no_matching_servers => :continue, :only => {:primary => true}, :except => { :no_release => true } do
    return if ENV['SKIP_MIGRATE']

    CapistranoEvroneRecipes::Util.ensure_changed_remote_dirs(self, "db/migrate") do
      run "cd #{release_path} && #{fetch :rake} RAILS_ENV=#{rails_env} db:migrate"
    end
  end
end

after "deploy:finalize_update", "deploy:migrate"
