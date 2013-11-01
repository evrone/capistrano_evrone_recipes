_cset(:runit_export_path)   { "#{latest_release}/var/services" }
_cset(:runit_services_path) { "#{deploy_to}/services" }
_cset(:runit_export_cmd)    { "#{fetch :bundle_cmd} exec foreman export runitu" }
_cset(:runit_procfile)      { "Procfile" }
_cset(:foreman_concurency)  { nil }
_cset(:runit_restart_timeout) { 10 }
_cset(:runit_restart_cmd)   { "sv -w #{fetch :runit_restart_timeout, 10} -v t $(pwd)/* || echo 'failed'" }

namespace :runit do

  desc "Restart Procfile services"
  task :restart, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    if find_servers_for_task(current_task).any?
      cmd = %Q{
        if [ -d #{runit_export_path} ] ; then
          echo -n "----> Update services" ;
          rm -rf #{runit_services_path}/* ;
          sync ;
          cp -r #{runit_export_path}/* #{runit_services_path}/ ;
          sync ;
          rm -rf #{runit_export_path} ;
        else
          echo -n "----> Restart services" ;
          test $(ls -1 #{runit_services_path} | wc -l) -eq 0 ||
            (cd #{fetch :runit_services_path} && #{fetch :runit_restart_cmd, "/bin/true"}) ;
        fi
      }.compact
      run cmd
    end
  end

  desc "Stop services"
  task :stop, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    if find_servers_for_task(current_task).any?
      run "sv -w 10 force-stop #{runit_services_path}/*"
    end
  end

  desc "Start services"
  task :start, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    if find_servers_for_task(current_task).any?
      run "sv -v start #{runit_services_path}/*"
    end
  end

  desc "Export Procfile"
  task :export, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    if find_servers_for_task(current_task).any?
      env = %{ RAILS_ENV=#{rails_env} }.strip + "\n"
      put(env, "#{latest_release}/.env")

      c = fetch(:foreman_concurency) ? "-c #{fetch :foreman_concurency}" : ""
      diff = ENV['FORCE'] ?
        %{ /bin/false } :
        %{ diff -q #{previous_release}/#{runit_procfile} #{latest_release}/#{runit_procfile} > /dev/null }
      cmd = %{
        #{diff} || (
          echo -n "----> Export #{runit_procfile}" ;
          cd #{latest_release} &&
          #{runit_export_cmd} #{runit_export_path}
            -e #{latest_release}/.env
            -l #{shared_path}/log
            -f #{latest_release}/#{runit_procfile}
            --root=#{current_path}
            -a #{application} #{c} > /dev/null &&

            for i in $(ls #{runit_export_path}/); do
              sed -i 's|#{runit_export_path}|#{runit_services_path}|g' #{runit_export_path}/${i}/run ;
            done
         )
      }.compact
      run cmd
    end
  end
end

after "deploy:finalize_update", "runit:export"
after "deploy:start", "runit:start"
after "deploy:stop", "runit:stop"
after "deploy:restart", "runit:restart"
