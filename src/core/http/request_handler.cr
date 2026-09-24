require "http/server"

module Marble::Core::HTTP
  abstract class RequestHandler
    abstract def handle(ctx : ::HTTP::Server::Context)
  end
end
