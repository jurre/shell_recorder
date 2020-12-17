# frozen_string_literal: true

Dir[File.join(__dir__, "adapters", "*.rb")].sort.each { |file| require file }

module ShellRecorder
  # Adapters holds the various implementations that hook into libraries
  # that interact with the shell.
  module Adapters
  end
end
