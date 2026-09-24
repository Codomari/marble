require "./config"
require "./connection"

module Marble::Config
  class Redis
    getter connection : Config::Connection

    def initialize(@connection : Config::Connection)
    end
  end
end
