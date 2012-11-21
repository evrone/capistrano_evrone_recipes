namespace :rails do
  desc "Run rails console"
  desc "open remote console (only on the last machine from the :app roles)"
  task :console, :roles => :app do
    server = find_servers_for_task(current_task).first
    if server
      exec "ssh -A #{server} -t 'cd #{current_path} && #{fetch :bundle_cmd} exec script/rails console #{rails_env}'"
    end
  end

  desc "Run rails dbconsole"
  desc "open remote dbconsole (only on the primary db machine)"
  task :dbconsole, :roles => :db, :only => { :primary => true } do
    server = find_servers_for_task(current_task).first
    if server
      exec "ssh -A #{server} -t 'cd #{current_path} && #{fetch :bundle_cmd} exec script/rails dbconsole #{rails_env}'"
    end
  end
end
