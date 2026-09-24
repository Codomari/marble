require "./config"

module Marble::Config
  class Tls
    getter cert : String
    getter key : String

    def initialize(@cert : String, @key : String)
    end
  end
end
