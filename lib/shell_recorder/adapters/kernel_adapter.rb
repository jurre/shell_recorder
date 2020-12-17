# frozen_string_literal: true

require "shell_recorder/command"

module ShellRecorder
  module Adapters
    # KernelAdapter augments shell methods on the Kernel module
    module KernelAdapter
      def self.enable!
        @enabled = true
      end

      def self.disable!
        @enabled = false
      end

      def self.enabled?
        @enabled
      end

      ::Kernel.module_eval do
        alias_method :original_backtick, :`

        def `(cmd)
          return original_backtick(cmd) unless recording_enabled?

          command = ShellRecorder.registry.find_recording(cmd)
          return command.stdout if command

          result = original_backtick(*cmd)
          ShellRecorder.config.registry.record(
            ShellRecorder::Command.new(binary: cmd, status: 0, stdin: "", stdout: result, stderr: "")
          )
          result
        end

        private

        def recording_enabled?
          ShellRecorder::Adapters::KernelAdapter.enabled?
        end
      end
    end
  end
end
