# frozen_string_literal: true

require "shell_recorder/adapters/kernel_adapter"

module ShellRecorder
  module LibraryHooks
    # Kernel hooks into the ::Kernel module.
    class Kernel
      def self.configure_library_hook
        Adapters::KernelAdapter.enable!
      end

      configure_library_hook
    end
  end
end
