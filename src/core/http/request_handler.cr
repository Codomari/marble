require "http/server"

module Marble::Core::HTTP::RequestHandler
  abstract def handle(ctx : ::HTTP::Server::Context)
end
