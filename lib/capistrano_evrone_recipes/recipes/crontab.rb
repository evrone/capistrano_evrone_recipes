set(:whenever_command)   { "#{fetch(:bundle_cmd)} exec whenever" }
set(:whenever_variables) {"\"environment=#{rails_env}&path=#{current_path}&output=#{shared_path}/log/crontab.log\"" }
set(:whenever_roles)     { :crontab }

require "whenever/capistrano/recipes"

namespace :crontab do
  desc "Generate crontab from config/whenever.rb"
  task :generate, :roles => :crontab, :on_no_matching_servers => :continue, :except => { :no_release => true }  do
    CapistranoEvroneRecipes::Util.ensure_changed_remote_files(self, "config/schedule.rb") do
      find_and_execute_task("whenever:update_crontab")
    end
  end

  desc "Clear crontab"
  task :clear, :roles => :crontab, :on_no_matching_servers => :continue, :except => { :no_release => true }  do
    find_and_execute_task("whenever:clear_crontab")
  end
end

after "deploy:finalize_update", 'crontab:generate'
