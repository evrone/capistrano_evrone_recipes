desc "Login to remote host"
task :login do
  hostname = find_servers_for_task(current_task).first
  port = hostname.port || fetch(:port, 22)
  exec "ssh -A -p #{port} -l #{user} #{hostname} -t 'cd #{current_path} && ${SHELL} -l'"
end
