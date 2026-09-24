module Marble::Config
  class Connection
    getter uri : String

    def initialize(@uri : String)
    end
  end
end
