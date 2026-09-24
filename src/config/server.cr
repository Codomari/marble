require "./config"
require "./tls"

module Marble::Config
  class Server
    getter? enabled : Bool
    getter host : String
    getter port : Int32
    getter tls : Config::Tls?

    def initialize(@enabled : Bool, @host : String, @port : Int32, @tls : Config::Tls? = nil)
    end

    def enabled : Bool
      @enabled
    end
  end
end
