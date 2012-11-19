namespace :newrelic do
  desc "Record deploy to newrelic"
  task :deploy_notify, :roles => :app, :on_no_matching_servers => :continue, :except => { :no_release => true } do
    system "curl -H \"x-api-key:#{newrelic_api_key}\" -d \"deployment[app_name]=#{newrelic_app}\" -d \"deployment[revision]=#{current_revision}\" -d \"deployment[user]=#{ENV['USER']}\"  https://api.newrelic.com/deployments.xml 1>/dev/null"  unless newrelic_app.empty?
  end
end
