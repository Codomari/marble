require "./config"

module Marble::Config
  class Startup
    getter config : Config
    getter args : Array(String)

    def initialize(@config : Config, @args : Array(String))
    end
  end
end
