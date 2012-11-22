_cset(:runit_export_path)   { "#{latest_release}/var/services" }
_cset(:runit_services_path) { "#{deploy_to}/services" }
_cset(:runit_export_cmd)    { "#{fetch :bundle_cmd} exec foreman export runitu" }
_cset(:runit_procfile)      { "#{latest_release}/Procfile" }
_cset(:foreman_concurency)  { nil }

namespace :runit do

  desc "Restart Procfile services"
  task :restart, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    current_link = capture("readlink #{runit_services_path}/current || echo").to_s.strip
    if current_link == runit_export_path
      stop
      start
    else
      relink
    end
  end

  task :relink, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = <<-EOF
    (test -L previous && readlink previous | xargs rm -rf) ;
    rm -f current.new &&
    ln -s #{runit_export_path} current.new &&
    rm -f previous &&
    (test -L current && mv current previous) || true
    && mv current.new current
    EOF
    cmd = cmd.gsub(/\n/, " ").gsub(/ +/, " ")
    run("cd #{runit_services_path} && #{cmd}")
  end

  desc "Stop services"
  task :stop, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = "for i in `ls -1 #{runit_services_path}/current`; do"
    cmd << " sv -w 10 force-stop #{runit_services_path}/current/${i} ; done"
    run(cmd)
  end

  desc "Start services"
  task :start, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    cmd = "for i in `ls -1 #{runit_services_path}/current`; do"
    cmd << " sv -v -w 10 up #{runit_services_path}/current/${i} ; done"
    run(cmd)
  end

  desc "Export Procfile"
  task :export, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    env = <<-EOF
RAILS_ENV=#{rails_env}
EOF
    put(env, "#{release_path}/.env")

    conc = fetch(:foreman_concurency) ? "-c #{fetch :foreman_concurency}" : ""
    run "cd #{release_path} && #{runit_export_cmd} #{runit_export_path} -e #{release_path}/.env -l #{shared_path}/log -f #{runit_procfile} --root=#{release_path} -a #{application} #{conc} > /dev/null"
  end
end

after "deploy:finalize_update", "runit:export"
