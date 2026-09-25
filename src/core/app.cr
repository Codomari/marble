require "../config/parser"

require "./generators/uid_generator"
require "./secret"
require "./structs/service_info"

module Marble::Core
  abstract class App
    private alias Config = Marble::Config::Root
    private alias Secret = Marble::Core::Secret
    private alias UIDGenerator = Marble::Core::Generators::UIDGenerator
    private alias ServiceInfo = Marble::Core::Structs::ServiceInfo

    getter service_info : ServiceInfo
    getter uid_generator : UIDGenerator?

    protected getter app_name : String

    def initialize(@app_name : String, service_name : String, @config : Config? = nil)
      @service_info = ServiceInfo.new(service_name)
      @uid_generator = nil
      @config.try do |config|
        Secret.init(config.secret)
        @uid_generator = UIDGenerator.new(Secret.secret_key)
      end
    end

    def run(_args : Array(String) = ARGV) : Nil
      configure_app
    end

    protected abstract def configure_app : Nil

    protected def config : Config
      @config || raise ArgumentError.new("configuration file is required. Provide --config=path/to/config.yaml.")
    end
  end
end
