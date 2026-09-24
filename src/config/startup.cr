require "./root"

module Marble::Config
  class Startup
    getter config : Root
    getter args : Array(String)

    def initialize(@config : Root, @args : Array(String))
    end
  end
end
