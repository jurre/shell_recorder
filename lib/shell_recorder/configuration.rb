# frozen_string_literal: true

require "set"

require "shell_recorder/registry"
require "shell_recorder/persister"

module ShellRecorder
  # Configuration holds settings that Shellregistry is configured with.
  class Configuration
    attr_reader :hooks, :enabled
    attr_accessor :registry, :persister

    def initialize
      @hooks = Set.new
      @enabled = false
      @registry = Registry.new
      @persister = Persister.new
    end

    def hook_into(*hooks)
      hooks.each do |hook|
        load_library_hook(hook)
        @hooks << hook
      end
    end

    def enable
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def enabled?
      @enabled
    end

    def storage_location=(path)
      persister.storage_location = path
    end

    private

    def load_library_hook(hook)
      require "shell_recorder/library_hooks/#{hook}"
    rescue LoadError
      raise ArgumentError, "#{hook.inspect} is not a supported ShellRecorder library hook."
    end
  end
end
