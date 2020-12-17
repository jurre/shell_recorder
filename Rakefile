# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Default: Run specs."
task default: "spec:unit"

namespace :spec do
  desc "Run unit specs"
  RSpec::Core::RakeTask.new("unit") do |t|
    t.pattern = "spec/shell_recorder/**/*_spec.rb"
  end
end
