# frozen_string_literal: true

require "digest"

module ShellRecorder
  # Recorder records shell commands in memory.
  class Registry
    def initialize
      @recordings = {}
    end

    def record(command)
      @recordings[key(command.binary, command.stdin)] = command
    end

    def load(fixture)
      YAML.safe_load(fixture)["recordings"].each do |recording|
        args = recording.transform_keys(&:to_sym)
        command = ShellRecorder::Command.new(**args)
        record(command)
      end
    end

    def recordings
      @recordings.values
    end

    def find_recording(binary, stdin = nil)
      @recordings[key(binary, stdin)]
    end

    def flush
      @recordings.values.tap do
        @recordings = {}
      end
    end

    private

    def key(binary, stdin)
      Digest::SHA256.hexdigest([binary, stdin].join(":"))
    end
  end
end
