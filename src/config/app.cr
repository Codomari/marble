require "./config"
require "./secure_server"
require "./server"

module Marble::Config
  class App
    getter http : Config::Server
    getter https : Config::SecureServer

    def initialize(@http : Config::Server, @https : Config::SecureServer)
    end
  end
end
