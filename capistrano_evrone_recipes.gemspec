$:.unshift File.expand_path("../lib", __FILE__)
require "capistrano_evrone_recipes/version"

Gem::Specification.new do |s|
  s.name     = "capistrano_evrone_recipes"
  s.version  = CapistranoEvroneRecipes::Version

  s.author   = "Dmitry Galinsky"
  s.email    = "dima.exe@gmail.com"
  s.homepage = "http://github.com/dima-exe/capistrano_evrone_recipes"
  s.summary  = "Capistrano recipes used in evrone company"

  s.description = s.summary

  s.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.13.5"])
      s.add_runtime_dependency(%q<colored>, [">= 0"])
      s.add_runtime_dependency(%q<unicorn>, [">= 0"])
      s.add_runtime_dependency(%q<foreman_export_runitu>, [">= 0"])
      s.add_runtime_dependency(%q<whenever>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.13.5"])
      s.add_dependency(%q<colored>, [">= 0"])
      s.add_dependency(%q<unicorn>, [">= 0"])
      s.add_dependency(%q<foreman_export_runitu>, [">= 0"])
      s.add_dependency(%q<whenever>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.13.5"])
    s.add_dependency(%q<colored>, [">= 0"])
    s.add_dependency(%q<unicorn>, [">= 0"])
    s.add_dependency(%q<foreman_export_runitu>, [">= 0"])
    s.add_dependency(%q<whenever>, [">= 0"])
  end
end
