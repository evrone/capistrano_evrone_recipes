# PLEASE NOTE, THIS PROJECT IS NO LONGER BEING MAINTAINED
# Evrone collection of Capistrano recipes

We deploy a lot of Rails applications and our developers have to solve similar problems each time during the deployment: 
how to run workers, how to generate crontab, how to precompile assets faster and so on. This collection of recipes helps 
us to solve them.

<a href="https://evrone.com/?utm_source=github.com">
  <img src="https://evrone.com/logo/evrone-sponsored-logo.png"
       alt="Sponsored by Evrone" width="231">
</a>

## Getting Started
### Prerequisites

Recipe use:

* [`foreman`][foreman] + [`foreman_export_runitu`][runitu] to generate runit scripts with the Procfile
* [`whenever`][whenever] to generate crontab
* [`unicorn`][unicorn] to run the application

[foreman]: https://github.com/ddollar/foreman
[runitu]: https://github.com/evrone/foreman_export_runitu
[whenever]: https://github.com/javan/whenever
[unicorn]: http://unicorn.bogomips.org/


It also consider that you use *system wide rbenv* on the server.

### Installation

    gem 'capistrano_evrone_recipes', :require => false
    require "capistrano_evrone_recipes/capistrano"
    
Capistrano default variables:

    logger.level                   = Capistrano::Logger::DEBUG
    default_run_options[:pty]      = true
    ssh_options[:forward_agent]    = true
    set :bundle_cmd,                 "rbenv exec bundle"
    set :bundle_flags,               "--deployment --quiet --binstubs --shebang ruby-local-exec"
    set :rake,                       -> { "#{bundle_cmd} exec rake" }
    set :keep_releases,              7
    set :scm,                        "git"
    set :user,                       "deploy"
    set :deploy_via,                 :unshared_remote_cache
    set :copy_exclude,               [".git"]
    set :repository_cache,           -> { "#{deploy_to}/shared/#{application}.git" }
    set :normalize_asset_timestamps, false
    
To enable silent mode, add `ENV['CAP_SILENT_MODE']` before the `require 'capistrano_evrone_recipes/capistrano'` 
in your `Capfile`

![silent mode](https://www.evernote.com/shard/s38/sh/4ea45631-93bc-4c03-bad8-f0aa40ca637b/8680b09c40342c6a885212b212b1c746/res/b04ff7c4-b29c-41b2-ab0a-6664cf0b75b9/skitch.png)


### Usage

Capfile example:

    set :repository, "git@github.com:..."
    set :application, "my_cook_application"

    task :production do
      role  :web,     "web.example.com"
      role  :app,     "app.example.com"
      role  :crontab, "app.example.com"
      role, :db,      "db.example.com", :primary => true
      role, :worker,  "workers.example.com"
    end

    task :staging do
      server "stage.example.com", :web, :app, :crontab, :db, :worker
    end

As you can see, we use use roles to bind the tasks, and there are some additions to roles and additional roles:

**web** compiles assets if content of `app/assets` was changed since last deploy (add FORCE=1 to force the assets compilation)

**app** all files from `shared/config` is being symlinked to `current/config` like:

    shared/config/database.yml            -> current/config/database.yml
    shared/config/settings/production.yml -> current/config/settings/production.yml

**crontab** generates crontab with `whenever` gem, only if the content of `config/schedule.rb` was changed 
(add FORCE=1 to force the crontab generation)

**db** run migrations only if `db/migrate` was changed (add FORCE=1 to force migrations or SKIP_MIGRATION=1 to skip them)

**worker** Procfile exports runit configs to `deploy_to/application/services`

On **deploy:restart** unicorn and runit workers is being restarted.

You can use some extra `cap` tasks:

* `rails:console` to launch `rails console` on remote server
* `rails:dbconsole` to launch `rails dbconsole` on remote server
* `login` to open SSH session under user `deploy` and switch catalog to Capistrano's `current_path`

**Important**

To run succesfully together with system wide rbenv, all you tasks in Procfile must be started with `rbenv exec`

## Contributing

Please read [Code of Conduct](CODE-OF-CONDUCT.md) and [Contributing Guidelines](CONTRIBUTING.md) for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, 
see the [tags on this repository](https://github.com/evrone/capistrano_evrone_recipes/tags). 

## Authors

* [Dmitry Galinsky](https://github.com/dmexe) - *Initial work*

See also the list of [contributors](https://github.com/evrone/capistrano_evrone_recipes/contributors) who participated in this project.

## License

This project is licensed under the [MIT License](LICENSE).
