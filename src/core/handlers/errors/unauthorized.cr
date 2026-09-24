require "json"
require "../../http/request_handler"

module Marble::Core::Handlers::Errors
  class Unauthorized
    include Marble::Core::HTTP::RequestHandler

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 401
      ctx.response.content_type = "application/json"
      {
        "status" => "error",
        "error"  => {
          "code"    => "unauthorized",
          "message" => "You're not authorized to access requested resource",
        },
      }.to_json
    end
  end
end
