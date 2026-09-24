require "file_utils"
require "./root"
require "./example"

module Marble::Config
  class Generator
    def self.generate!(path : String) : Nil
      raise ArgumentError.new("config generation path must not be empty") if path.empty?
      raise ArgumentError.new("config file already exists: #{path}") if File.exists?(path)

      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname) unless dirname == "."
      File.write(path, Example::CONTENT)
    end
  end
end
