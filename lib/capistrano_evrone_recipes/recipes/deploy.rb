namespace :deploy do

  task :symlink_configs do
    s = "cd #{shared_path}/config && "
    s << "for i in `find . -type f | sed 's/^\\.\\///'` ; do "
    s << "echo \"> ${i}\" ;"
    s << "rm -f #{release_path}/config/${i} ;"
    s << "ln -snf #{shared_path}/config/${i} #{release_path}/config/${i} ; done"
    run s
  end

  task :start, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    CapistranoEvroneRecipes::Util.with_roles(self, :app)    { unicorn.start }
    CapistranoEvroneRecipes::Util.with_roles(self, :worker) { runit.start }
  end

  task :stop, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    CapistranoEvroneRecipes::Util.with_roles(self, :app)    { unicorn.stop }
    CapistranoEvroneRecipes::Util.with_roles(self, :worker) { runit.stop }
  end

  task :restart, :on_no_matching_servers => :continue, :except => {:no_release => true} do
    CapistranoEvroneRecipes::Util.with_roles(self, :app)    { unicorn.restart }
    CapistranoEvroneRecipes::Util.with_roles(self, :worker) { runit.restart }
  end
end

after 'deploy:finalize_update', 'deploy:symlink_configs'

