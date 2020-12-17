# frozen_string_literal: true

module ShellRecorder
  # Command is a recording of a command
  class Command
    attr_reader :binary, :status, :stdin, :stdout, :stderr

    def initialize(binary:, status:, stdin:, stdout:, stderr:)
      @binary = binary
      @status = status
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
    end

    def ==(other)
      return false unless other.is_a? self.class

      binary == other.binary &&
        status == other.status &&
        stdin == other.stdin &&
        stdout == other.stdout &&
        stderr == other.stderr
    end

    def to_h
      {
        "binary" => binary,
        "stdin" => stdin,
        "status" => status,
        "stdout" => stdout,
        "stderr" => stderr
      }
    end
  end
end
