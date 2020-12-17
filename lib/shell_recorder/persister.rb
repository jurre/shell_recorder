# frozen_string_literal: true

require "fileutils"

module ShellRecorder
  # Persist recordings
  class Persister
    def storage_location=(dir)
      FileUtils.mkdir_p(dir) if dir
      @storage_location = dir ? absolute_path_for(dir) : nil
    end

    def load(name)
      path = absolute_path_to_file(name + ".yml")
      return nil unless File.exist?(path)

      File.binread(path)
    end

    def store(name, content)
      path = absolute_path_to_file(name + ".yml")
      directory = File.dirname(path)
      FileUtils.mkdir_p(directory) unless File.exist?(directory)
      File.binwrite(path, content)
    end

    private

    attr_reader :storage_location

    def absolute_path_to_file(file_name)
      return nil unless storage_location

      File.join(storage_location, sanitized_file_name_from(file_name))
    end

    def absolute_path_for(path)
      Dir.chdir(path) { Dir.pwd }
    end

    def sanitized_file_name_from(file_name)
      parts = file_name.to_s.split(".")

      file_extension = ".#{parts.pop}" if parts.size > 1 && !parts.last.include?(File::SEPARATOR)

      file_name = parts.join(".").gsub(%r{[^[:word:]\-/]+}, "_") + file_extension.to_s
      file_name.downcase!
      file_name
    end
  end
end
