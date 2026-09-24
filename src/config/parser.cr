require "yaml"
require "./config"
require "./app"
require "./connection"
require "./database"
require "./redis"
require "./secure_server"
require "./server"
require "./startup"
require "./storage"
require "./tls"

module Marble::Config
  class Parser
    def self.parse(path : String) : Config
      root = YAML.parse(File.read(path))

      Config.new(
        {
          "api"  => parse_app(root, "api"),
          "chat" => parse_app(root, "chat"),
          "game" => parse_app(root, "game"),
        },
        Config::Database.new(Config::Connection.new(string_at(root, ["database", "connection", "uri"]))),
        Config::Redis.new(Config::Connection.new(string_at(root, ["redis", "connection", "uri"]))),
        string_at(root, ["secret"]),
        Config::Storage.new(
          string_at(root, ["storage", "root"]),
          string_at(root, ["storage", "users"])
        )
      )
    end

    private def self.parse_app(root : YAML::Any, name : String) : Config::App
      Config::App.new(
        parse_server(root, ["apps", name, "http"]),
        parse_secure_server(root, ["apps", name, "https"])
      )
    end

    private def self.parse_server(root : YAML::Any, path : Array(String)) : Config::Server
      Config::Server.new(
        bool_at(root, path + ["enabled"]),
        string_at(root, path + ["host"]),
        int_at(root, path + ["port"])
      )
    end

    private def self.parse_secure_server(root : YAML::Any, path : Array(String)) : Config::SecureServer
      Config::SecureServer.new(
        bool_at(root, path + ["enabled"]),
        string_at(root, path + ["host"]),
        int_at(root, path + ["port"]),
        Config::Tls.new(
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
