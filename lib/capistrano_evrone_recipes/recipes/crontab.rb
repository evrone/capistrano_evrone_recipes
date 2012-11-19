set :crontab_work_dir, "/u/crontab"
set :crontab_user_file, "user.crontab"

namespace :crontab do
  desc "Generate crontab from config/whenever.rb"
  task :generate, :roles => :crontab, :on_no_matching_servers => :continue, :except => { :no_release => true }  do
    CapistranoEvroneRecipes::Util.ensure_changed_remote_files(self, "config/schedule.rb", "CRONTAB") do
      options = "environment=#{rails_env}&path=#{current_path}&output=#{shared_path}/log/crontab.log"
      whenever_file = "#{release_path}/config/schedule.rb"
      run "test -d #{crontab_work_dir} || mkdir -p #{crontab_work_dir}"
      run "cd #{release_path} && bundle exec whenever --set '#{options}' > #{crontab_work_dir}/#{application}.crontab"
      run "rm -f #{crontab_work_dir}/#{crontab_user_file}"
      run "cat #{crontab_work_dir}/*.crontab > #{crontab_work_dir}/#{crontab_user_file}"
      run "crontab #{crontab_work_dir}/#{crontab_user_file}"
    end
  end
end

after "deploy:finalize_update", 'crontab:generate'
