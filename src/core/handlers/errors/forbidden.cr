require "../../http/request_handler"

module Marble::Core::Handlers::Errors
  class Forbidden
    include Marble::Core::HTTP::RequestHandler

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 403
      ctx.response.content_type = "application/json"
      {
        "status" => "error",
        "error"  => {
          "code"    => "forbidden",
          "message" => "Access to requested resource forbidden",
        },
      }.to_json
    end
  end
end
