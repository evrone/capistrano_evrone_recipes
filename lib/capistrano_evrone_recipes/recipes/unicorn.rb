_cset(:unicorn_binary) { "#{fetch :bundle_cmd} exec unicorn" }
_cset(:unicorn_config) { "#{fetch :current_path}/config/unicorn.rb" }
_cset(:unicorn_pid)    { "#{fetch :current_path}/tmp/pids/unicorn.pid" }

namespace :unicorn do
  desc "Restart unicorn"
  task :restart, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    cmd = <<-EOF
if [ -f #{fetch :unicorn_pid} ];
then
  kill -s USR2 `cat #{fetch :unicorn_pid}` &&
  TIMES=1 &&
  echo 'Please wait unicorn restart...' &&
  sleep 1 &&
  (while [ -e #{fetch :unicorn_pid}.oldbin ] ; do sleep 2; TIMES=$TIMES+2; done) &&
  echo "Unicorn restart time: $TIMES sec" ;
fi
EOF
    run cmd.gsub(/\n/, " ").gsub(/ +/, " ")
  end

  desc "Fast restart unicorn"
  task :fast_restart, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "test -f #{fetch :unicorn_pid} ] && kill -s USR2 `cat #{fetch :unicorn_pid}`"
  end

  desc "Start unicorn"
  task :start, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "cd #{current_path} && env #{fetch :unicorn_binary} -c #{fetch :unicorn_config} -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :roles => :app, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    run "test -f #{fetch :unicorn_pid} && kill `cat #{fetch :unicorn_pid}`"
  end

  desc "Graceful stop unicorn"
  task :graceful_stop, :on_no_matching_servers => :continue, :roles => :app, :except => { :no_release => true } do
    run "test -f #{fetch :unicorn_pid} && kill -s QUIT `cat #{fetch :unicorn_pid}`"
  end
end
