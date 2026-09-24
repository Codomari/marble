require "./secure_server"
require "./server"

module Marble::Config
  class App
    getter http : Server
    getter https : SecureServer

    def initialize(@http : Server, @https : SecureServer)
    end
  end
end
