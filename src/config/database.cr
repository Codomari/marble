require "./config"
require "./connection"

module Marble::Config
  class Database
    getter connection : Config::Connection

    def initialize(@connection : Config::Connection)
    end
  end
end
