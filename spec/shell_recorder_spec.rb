# frozen_string_literal: true

require "spec_helper"
require "shell_recorder"
require "shell_recorder/adapters/open3_adapter"
require "fileutils"

describe ShellRecorder do
  describe ".configure" do
    it "can configure which library to hook into" do
      described_class.configure do |config|
        config.hook_into :open3
      end

      expect(described_class.config.hooks).to include(:open3)
    end

    it "raises a helpful error if there is no libary hook available" do
      expect do
        described_class.configure do |config|
          config.hook_into :non_existent
        end
      end.to raise_error(ArgumentError, ":non_existent is not a supported ShellRecorder library hook.")
    end

    it "can be enabled" do
      described_class.configure(&:enable)

      expect(described_class.config.enabled?).to eq(true)
    end

    it "can be disabled" do
      described_class.configure do |config|
        config.enable
        config.disable
      end

      expect(described_class.config.enabled?).to eq(false)
    end
  end

  describe ".use_recording" do
    before do
      described_class.configure do |config|
        config.hook_into :open3
        config.storage_location = File.join(__dir__, "fixtures/shell_recordings")
      end
    end

    it "stores a new recording if one does not exist" do
      described_class.use_recording("test pwd") do
        Open3.capture3("pwd")
      end

      expect(File).to exist(fixture_path("test_pwd"))

      clear_fixture("test_pwd.yml")
    end

    it "uses the recording if one does exist" do
      described_class.use_recording("sleeping") do
        stdout, stderr, status = Open3.capture3("sleep 10 && echo sup")

        expect([stdout, stderr, status]).to eq(["sup\n", "", 0])
      end
    end
  end

  private

  def clear_fixture(name)
    FileUtils.rm(fixture_path(name)) if File.exist?(fixture_path(name))
  end

  def fixture_path(name)
    File.join(__dir__, "fixtures/shell_recordings", name)
  end
end
