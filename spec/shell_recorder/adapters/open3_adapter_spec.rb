# frozen_string_literal: true

require "spec_helper"
require "shell_recorder/adapters/open3_adapter"
require "shell_recorder/command"

describe ShellRecorder::Adapters::Open3Adapter do
  before do
    ShellRecorder.configure do |config|
      config.hook_into :open3
    end

    described_class.enable!
    ShellRecorder.registry.flush
  end

  describe "Open3#popen3" do
    it "records shell interactions" do
      Open3.capture3("wc -l", stdin_data: "foo\nbar\nbaz")

      expect(ShellRecorder.registry.recordings.last).to eq(
        ShellRecorder::Command.new(
          binary: "wc -l",
          status: 0,
          stdin: "foo\nbar\nbaz",
          stdout: "       2\n",
          stderr: ""
        )
      )
    end

    it "calls returns the results from the original method" do
      result = Open3.capture3("wc -l", stdin_data: "foo\nbar\nbaz")

      expect(result).to eq(["       2\n", "", 0])
    end

    it "does not record data when it is disabled" do
      described_class.disable!

      Open3.capture3("wc -l", stdin_data: "foo\nbar\nbaz")

      expect(ShellRecorder.registry.recordings).to be_empty
    end

    it "returns the recorded fixture if it exists" do
      record_fixture(binary: "wc -l", stdin: "foo\nbar\nbaz", status: 2, stdout: "", stderr: "oh no!")

      result = Open3.capture3("wc -l", stdin_data: "foo\nbar\nbaz")

      expect(result).to eq(["", "oh no!", 2])
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
