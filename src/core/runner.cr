require "../config/cli"
require "./app"

module Marble
  def self.run(app_class : Core::App.class, args : Array(String) = ARGV) : Nil
    startup = begin
      Config::Cli.load!(args)
    rescue ex
      abort ex.message || "failed to load config"
    end

    return unless startup

    app_class.new(startup.config).run(startup.args)
  end
end
