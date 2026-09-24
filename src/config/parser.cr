require "yaml"
require "./root"
require "./app"
require "./connection"
require "./secure_server"
require "./server"
require "./startup"
require "./storage"
require "./tls"

module Marble::Config
  class Parser
    def self.parse(path : String) : Root
      root = YAML.parse(File.read(path))

      Root.new(
        {
          "server"  => parse_app(root, "server"),
        },
        string_at(root, ["secret"]),
        Storage.new(
          string_at(root, ["storage", "root"]),
          string_at(root, ["storage", "users"])
        )
      )
    end

    private def self.parse_app(root : YAML::Any, name : String) : App
      App.new(
        parse_server(root, ["apps", name, "http"]),
        parse_secure_server(root, ["apps", name, "https"])
      )
    end

    private def self.parse_server(root : YAML::Any, path : Array(String)) : Server
      Server.new(
        bool_at(root, path + ["enabled"]),
        string_at(root, path + ["host"]),
        int_at(root, path + ["port"])
      )
    end

    private def self.parse_secure_server(root : YAML::Any, path : Array(String)) : SecureServer
      SecureServer.new(
        bool_at(root, path + ["enabled"]),
        string_at(root, path + ["host"]),
        int_at(root, path + ["port"]),
        Tls.new(
          string_at(root, path + ["tls", "cert"]),
          string_at(root, path + ["tls", "key"])
        )
      )
    end

    private def self.value_at(root : YAML::Any, path : Array(String)) : YAML::Any
      current = root
      path.each { |key| current = current[key] }
      current
    rescue KeyError
      raise ArgumentError.new("missing required config key: #{path.join(".")}")
    end

    private def self.string_at(root : YAML::Any, path : Array(String)) : String
      value_at(root, path).as_s
    rescue TypeCastError
      raise ArgumentError.new("config key #{path.join(".")} must be a string")
    end

    private def self.int_at(root : YAML::Any, path : Array(String)) : Int32
      value_at(root, path).as_i
    rescue TypeCastError
      raise ArgumentError.new("config key #{path.join(".")} must be an integer")
    end

    private def self.bool_at(root : YAML::Any, path : Array(String)) : Bool
      value_at(root, path).as_bool
    rescue TypeCastError
      raise ArgumentError.new("config key #{path.join(".")} must be a boolean")
    end
  end
end
