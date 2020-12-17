# frozen_string_literal: true

require "spec_helper"
require "shell_recorder/command"
require "shell_recorder/registry"

describe ShellRecorder::Registry do
  describe "#record" do
    it "records commands" do
      command = build_command
      recorder = described_class.new

      recorder.record(command)

      expect(recorder.recordings.last).to eq(command)
    end

    xit "handles recording the same command multiple times" do
      # TODO(@Jurre)
      # Figure out how to store the command in such a way that we can grab it
      # based on the input, probably by storing some sequence
    end
  end

  describe "#flush" do
    it "returns all the recordings" do
      command = build_command
      recorder = described_class.new

      recorder.record(command)

      expect(recorder.flush).to eq([command])
    end

    it "removes all the recordings afterwards" do
      command = build_command
      recorder = described_class.new

      recorder.record(command)
      recorder.flush

      expect(recorder.recordings).to eq([])
    end
  end

  private

  def build_command
    ShellRecorder::Command.new(
      binary: "wc -l",
      stdin: "foo\nbar\nbaz",
      status: 0,
      stdout: "       2\n",
      stderr: ""
    )
  end
end
