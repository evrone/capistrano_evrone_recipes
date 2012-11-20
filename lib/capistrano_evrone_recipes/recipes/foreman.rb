_cset(:foreman_services_path) { "#{deploy_to}/services/#{release_name}" }
_cset(:foreman_cmd)           { "#{fetch :bundle_cmd} exec foreman export runitu" }
_cset(:foreman_procfile)      { "#{release_path}/Procfile" }
_cset(:foreman_concurency)    { nil }

namespace :foreman do

  desc "Restart Procfile services"
  task :restart, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = <<-EOF
    (test -L previous && readlink previous | xargs rm -rf) ;
    rm -f current.new &&
    ln -s #{fetch :foreman_services_path} current.new &&
    rm -f previous &&
    (test -L current && mv current previous) || true
    && mv current.new current
    EOF
    cmd = cmd.gsub(/\n/, " ").gsub(/ +/, " ")
    run("cd #{deploy_to}/services && #{cmd}")
  end

  desc "Stop services"
  task :stop, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = "for i in `ls -1 #{deploy_to}/services/current`; do"
    cmd << " sv -w 10 down #{deploy_to}/services/current/${i} ; done"
    run(cmd)
  end

  desc "Start services"
  task :start, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = "for i in `ls -1 #{deploy_to}/services/current`; do"
    cmd << " sv -v -w 10 up #{deploy_to}/services/current/${i} ; done"
    run(cmd)
  end

  desc "Export Procfile"
  task :export, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    env = <<-EOF
RAILS_ENV=#{rails_env}
EOF
    put(env, "#{release_path}/.env")

    conc = fetch(:foreman_concurency) ? "-c #{fetch :foreman_concurency}" : ""
    run "cd #{release_path} && #{fetch :foreman_cmd} #{fetch :foreman_services_path} -e #{release_path}/.env -l #{shared_path}/log -f #{fetch :foreman_procfile} --root=#{release_path} -a #{application} #{conc} > /dev/null"
  end
end

after "deploy:finalize_update", "foreman:export"
