# frozen_string_literal: true

require "spec_helper"
require "shell_recorder/adapters/kernel_adapter"
require "shell_recorder/command"

describe ShellRecorder::Adapters::KernelAdapter do
  before do
    ShellRecorder.configure do |config|
      config.hook_into :kernel
    end

    described_class.enable!
    ShellRecorder.registry.flush
  end

  describe "Kernel#`" do
    it "records shell interactions" do
      `echo abc`

      expect(ShellRecorder.registry.recordings.last).to eq(
        ShellRecorder::Command.new(
          binary: "echo abc",
          status: 0,
          stdin: "",
          stdout: "abc\n",
          stderr: ""
        )
      )
    end

    it "calls returns the results from the original method" do
      result = `echo abc`

      expect(result).to eq("abc\n")
    end

    it "does not record data when it is disabled" do
      described_class.disable!

      `echo abc`

      expect(ShellRecorder.registry.recordings).to be_empty
    end

    it "returns the recorded fixture if it exists" do
      record_fixture(binary: "echo abc", stdin: "", status: 2, stdout: "oh no!", stderr: "")

      result = `echo abc`

      expect(result).to eq("oh no!")
    end
  end

  private

  def record_fixture(binary:, stdin:, status:, stdout:, stderr:)
    ShellRecorder.registry.record(
      ShellRecorder::Command.new(
        binary: binary, status: status, stdin: stdin, stdout: stdout, stderr: stderr
      )
    )
  end
end
