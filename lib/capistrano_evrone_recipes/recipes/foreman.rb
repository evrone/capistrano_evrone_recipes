_cset :worker_list, []

namespace :foreman do
  task :restart, :roles => :worker, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    rpath = "#{release_path}/var/services"
    cmd = "if [ -d #{rpath} ]; then"
    cmd << " mkdir -p #{shared_path}/services;"
    cmd << " rm -rf #{shared_path}/services/*;"
    cmd << " for i in `ls -1 #{rpath}/` ; do ln -snf #{rpath}/${i} #{shared_path}/services/${i} ; done"
    cmd << " ; fi"
    run cmd
  end

  task :export, :except => { :no_release => true } do
    c = exists?(:foreman_concurency) ? "--concurrency=\"#{fetch(:foreman_concurency)}\"" : ""
    run "cd #{release_path} && bundle exec foreman export runitu #{release_path}/var/services -l #{shared_path}/log -f #{release_path}/Procfile --root=#{release_path} -a #{kk_repo_name} #{c} > /dev/null"
  end

  task :export_single, :roles => :worker_single, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    c = exists?(:foreman_concurency) ? "--concurrency=\"#{fetch(:foreman_concurency)}\"" : ""
    run "cd #{release_path} && bundle exec foreman export runitu #{release_path}/var/services -l #{shared_path}/log -f #{release_path}/Procfile_single --root=#{release_path} -a #{kk_repo_name} #{c} > /dev/null"
  end

end
