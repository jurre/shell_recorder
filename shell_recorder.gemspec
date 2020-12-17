# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "./lib/shell_recorder/version"

Gem::Specification.new do |spec|
  spec.name         = "shell_recorder"
  spec.version      = ShellRecorder::VERSION
  spec.summary      = "Record interactions with the shell"
  spec.description  = "Record interactions with the shell"

  spec.author       = "Jurre Stender"
  spec.email        = "jurre@github.com"
  spec.homepage     = "https://github.com/jurre/shell_recorder"
  spec.license      = "MIT"

  spec.require_path   = "lib"
  spec.files          = `git ls-files`.split("\n")
  spec.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths  = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop", "~> 1.6.1"
  spec.add_development_dependency "rubocop-rspec", "~> 2.0.1"
end
