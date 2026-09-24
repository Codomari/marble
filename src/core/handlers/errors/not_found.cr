require "json"
require "../../http/request_handler"

module Marble::Core::Handlers::Errors
  class NotFound
    include Marble::Core::HTTP::RequestHandler

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 404
      ctx.response.content_type = "application/json"
      {
        "status" => "error",
        "error"  => {
          "code"    => "not_found",
          "message" => "Requested resource not found",
        },
      }.to_json
    end
  end
end
