require "../config/parser"

require "./generators/uid_generator"
require "./secret"
require "./structs/service_info"

module Marble::Core
  abstract class App
    getter service_info : Structs::ServiceInfo
    getter uid_generator : Generators::UIDGenerator?

    protected getter app_name : String

    def initialize(@app_name : String, service_name : String, @config : Marble::Config::Root? = nil)
      @service_info = Structs::ServiceInfo.new(service_name)
      @uid_generator = nil
      @config.try do |config|
        Marble::Core::Secret.init(config.secret)
        @uid_generator = Generators::UIDGenerator.new(Marble::Core::Secret.secret_key)
      end
    end

    def run(_args : Array(String) = ARGV) : Nil
      configure_app
    end

    protected abstract def configure_app : Nil

    protected def config : Marble::Config::Root
      @config || raise ArgumentError.new("configuration file is required. Provide --config=path/to/config.yaml.")
    end
  end
end
