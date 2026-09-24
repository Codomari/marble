require "./server"
require "./tls"

module Marble::Config
  class SecureServer < Config::Server
    def initialize(enabled : Bool, host : String, port : Int32, @required_tls : Config::Tls)
      super(enabled, host, port, @required_tls)
    end

    def tls : Config::Tls
      @required_tls
    end
  end
end
