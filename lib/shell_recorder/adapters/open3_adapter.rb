# frozen_string_literal: true

require "open3"
require "shell_recorder/command"

module ShellRecorder
  module Adapters
    # Open3Adapter augments the ::Open3 class' public methods with versions that
    # record shell interactions.
    module Open3Adapter
      def self.enable!
        @enabled = true
      end

      def self.disable!
        @enabled = false
      end

      def self.enabled?
        @enabled
      end

      ::Open3.module_eval do
        class << self
          alias_method :original_capture3, :capture3
        end

        def self.capture3(*cmd) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          return original_capture3(*cmd) unless recording_enabled?

          binary = cmd.first
          stdin = cmd.last[:stdin_data] if cmd.size > 1

          command = ShellRecorder.registry.find_recording(binary, stdin)
          return command.stdout, command.stderr, command.status if command

          original_capture3(*cmd).tap do |stdout_str, stderr_str, status|
            ShellRecorder.config.registry.record(
              ShellRecorder::Command.new(binary: binary, status: status.to_i, stdin: stdin, stdout: stdout_str,
                                         stderr: stderr_str)
            )
          end
        end

        def self.recording_enabled?
          ShellRecorder::Adapters::Open3Adapter.enabled?
        end
        class << self
          private :recording_enabled?
        end
      end
    end
  end
end
