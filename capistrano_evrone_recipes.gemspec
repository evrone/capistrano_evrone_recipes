$:.unshift File.expand_path("../lib", __FILE__)
require "capistrano_evrone_recipes/version"

Gem::Specification.new do |gem|
  gem.name     = "capistrano_evrone_recipes"
  gem.version  = CapistranoEvroneRecipes::Version

  gem.author   = "Dmitry Galinsky"
  gem.email    = "dima.exe@gmail.com"
  gem.homepage = "http://github.com/dima-exe/capistrano_evrone_recipes"
  gem.summary  = "Capistrano recipes used in evrone company"

  gem.description = gem.summary

  gem.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

  gem.add_dependency "whenever"
  gem.add_dependency "foreman_export_runitu"
  gem.add_dependency "capistrano", '>= 2.13.5'
end
