_cset :rails_cmd, "bin/rails"

namespace :rails do
  desc "Run rails console"
  desc "open remote console (only on the last machine from the :app roles)"
  task :console, :roles => :app do
    server = find_servers_for_task(current_task).first
    if server
      exec "ssh -A #{server} -t 'cd #{current_path} && #{rails_cmd} console #{rails_env}'"
    end
  end

  desc "Run rails dbconsole"
  desc "open remote dbconsole (only on the primary db machine)"
  task :dbconsole, :roles => :db, :only => { :primary => true } do
    server = find_servers_for_task(current_task).first
    if server
      exec "ssh -A #{server} -t 'cd #{current_path} && #{rails_cmd} dbconsole #{rails_env}'"
    end
  end
end
