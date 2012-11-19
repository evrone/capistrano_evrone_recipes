namespace :rails do
  desc "Run rails console"
  desc "open remote console (only on the last machine from the :app roles)"
  task :console, :roles => :app do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -t 'source ~/.bashrc && #{current_path}/script/rails c #{rails_env}'"
  end

  desc "Run rails dbconsole"
  desc "open remote dbconsole (only on the primary db machine)"
  task :dbconsole, :roles => :db, :only => { :primary => true } do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -t 'source ~/.bashrc && #{current_path}/script/rails dbconsole #{rails_env}'"
  end
end
