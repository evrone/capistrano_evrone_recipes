$:.unshift File.expand_path("../lib", __FILE__)
require "capistrano_evrone_recipes/version"

Gem::Specification.new do |s|
  s.name     = "capistrano_evrone_recipes"
  s.version  = CapistranoEvroneRecipes::VERSION

  s.author   = "Dmitry Galinsky"
  s.email    = "dima.exe@gmail.com"
  s.homepage = "http://github.com/evrone/capistrano_evrone_recipes"
  s.summary  = "Capistrano recipes used in evrone company"

  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = ["lib"]

  s.add_runtime_dependency("capistrano", [">= 2.13.5"])
  s.add_runtime_dependency("colored", [">= 0"])
  s.add_runtime_dependency("foreman", [">= 0"])
  s.add_runtime_dependency("foreman_export_runitu", [">= 0"])
  s.add_runtime_dependency("whenever", ["~> 0.7.3"])
end
