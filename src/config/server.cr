require "./tls"

module Marble::Config
  class Server
    getter? enabled : Bool
    getter host : String
    getter port : Int32
    getter tls : Tls?

    def initialize(@enabled : Bool, @host : String, @port : Int32, @tls : Tls? = nil)
    end

    def enabled : Bool
      @enabled
    end
  end
end
