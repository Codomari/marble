require "./config"
require "./generator"
require "./parser"

module Marble::Config
  class Cli
    CONFIG_ARG_PREFIX     = "--config="
    GEN_CONFIG_ARG_PREFIX = "--gen-config="

    def self.load!(args : Array(String)) : Config::Startup?
      config_path = nil
      gen_config_path = nil
      remaining_args = [] of String

      args.each do |arg|
        if arg.starts_with?(CONFIG_ARG_PREFIX)
          raise ArgumentError.new("only one --config=path/to/config.yaml argument is allowed") if config_path

          config_path = arg[CONFIG_ARG_PREFIX.size..]
        elsif arg.starts_with?(GEN_CONFIG_ARG_PREFIX)
          raise ArgumentError.new("only one --gen-config=path/to/config.yaml argument is allowed") if gen_config_path

          gen_config_path = arg[GEN_CONFIG_ARG_PREFIX.size..]
        else
          remaining_args << arg
        end
      end

      if path = gen_config_path
        raise ArgumentError.new("--gen-config cannot be combined with --config") if config_path

        Config::Generator.generate!(path)
        return nil
      end

      path = config_path || raise ArgumentError.new(
        "configuration file is required. Provide --config=path/to/config.yaml."
      )
      raise ArgumentError.new("config path must not be empty") if path.empty?

      Config::Startup.new(Config::Parser.parse(path), remaining_args)
    end
  end
end
