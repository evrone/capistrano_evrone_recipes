namespace :unicorn do
  desc "Restart unicorn"
  task :restart, :role => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "if [ -f #{unicorn_pid} ] ; then kill -s USR2 `cat #{unicorn_pid}` ;fi && let a=1; echo 'Please wait unicorn restart...'; \
    sleep 1 && while [ -e #{unicorn_pid}.oldbin ] ; do sleep 2; let a=$a+2;  done; \
    echo \"Unicorn restart time: $a sec\""
  end

  desc "Fast restart unicorn"
  task :fast_restart, :role => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "if [ -f #{unicorn_pid} ] ; then kill -s USR2 `cat #{unicorn_pid}` ;fi"
  end

  desc "Start unicorn"
  task :start, :role => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :role => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "kill `cat #{unicorn_pid}`"
  end

  desc "Graceful stop unicorn"
  task :graceful_stop, :on_no_matching_servers => :continue, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
end
