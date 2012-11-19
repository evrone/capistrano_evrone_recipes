desc "Login to remote host"
task :login do
  hostname = find_servers_for_task(current_task).first
  exec "ssh -l #{user} #{hostname} -t 'cd #{current_path} && ${SHELL} -l'"
end
