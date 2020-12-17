# frozen_string_literal: true

require "shell_recorder/adapters/open3_adapter"

module ShellRecorder
  module LibraryHooks
    # Open3 hooks into the ::Open3 class.
    class Open3
      def self.configure_library_hook
        Adapters::Open3Adapter.enable!
      end

      configure_library_hook
    end
  end
end
