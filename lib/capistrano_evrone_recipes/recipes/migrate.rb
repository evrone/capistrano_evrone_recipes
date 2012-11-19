namespace :deploy do
  desc "Migrate database if has migration"
  task :migrate, :roles => :db, :on_no_matching_servers => :continue, :only => {:primary => true}, :except => { :no_release => true } do
    unless ENV["SKIP_MIGRATE"]
      if capture("diff -r #{previous_release}/db/migrate/ #{current_release}/db/migrate/ | wc -l").to_i > 0
        puts capture("diff -rN #{previous_release}/db/migrate/ #{current_release}/db/migrate/ | head -n 60")
        unless agree = Capistrano::CLI.ui.agree("Run migration, are you sure? (Yes, [No]) ")
            exit
        end
        run "cd #{current_release} && bundle exec rake RAILS_ENV=#{rails_env} db:migrate"
      else
        logger.info "Skipping db migrate because there were no changes in db/migrate"
      end
    end
  end
  desc "Force migrate"
  task :force_migrate, :roles => :db, :on_no_matching_servers => :continue, :only => {:primary => true}, :except => { :no_release => true } do
   run "cd #{current_release} && bundle exec rake RAILS_ENV=#{rails_env} #{asset_env} db:migrate"
  end
end
