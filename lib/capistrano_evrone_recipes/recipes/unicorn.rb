_cset(:unicorn_binary) { "#{fetch :bundle_cmd} exec unicorn" }
_cset(:unicorn_config) { "#{fetch :current_path}/config/unicorn.rb" }
_cset(:unicorn_pid)    { "#{fetch :current_path}/tmp/pids/unicorn.pid" }

namespace :unicorn do
  desc "Restart unicorn"
  task :restart, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    upid = fetch :unicorn_pid
    cmd = <<-EOF
if [ -f #{upid} ] ; then kill -s USR2 `cat #{upid}` ;fi && a=1;d=2; echo 'Please wait unicorn restart...'; sleep 1 && while [ -e #{upid}.oldbin ] ; do sleep 2; a=$(expr $a + $d);  done; echo "Unicorn restart time: $a sec"
EOF
    run cmd
  end

  desc "Start unicorn"
  task :start, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "cd #{current_path} && env #{fetch :unicorn_binary} -c #{fetch :unicorn_config} -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "test -f #{fetch :unicorn_pid} && kill `cat #{fetch :unicorn_pid}`"
  end
end

after "deploy:start", "unicorn:start"
after "deploy:stop", "unicorn:stop"
after "deploy:restart", "unicorn:restart"
