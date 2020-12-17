# frozen_string_literal: true

require "yaml"

require "shell_recorder/library_hooks"
require "shell_recorder/configuration"

# ShellRecorder records shell commands, and allows playback of those recording
# to avoid potential heavy work in tests.
module ShellRecorder
  extend self # rubocop:disable Style/ModuleFunction

  attr_accessor :config

  def configure
    yield(config)
  end

  def registry
    config.registry
  end

  def persister
    config.persister
  end

  def use_recording(name, &block)
    raise "ShellRecorder.use_recording requires a block" unless block

    if (fixture = persister.load(name))
      load_fixtures(fixture)
    end

    block.call

    persister.store(name, build_yamls_from_recordings(registry.flush))
  end

  def load_fixtures(fixture)
    registry.load(fixture)
  end

  def build_yamls_from_recordings(recordings)
    { "recordings" => recordings.map(&:to_h) }.to_yaml
  end

  self.config = Configuration.new
end
