require "../../http/request_handler"

module Marble::Core::Handlers::Errors
  class MethodNotAllowed
    include Marble::Core::HTTP::RequestHandler

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 405
      ctx.response.content_type = "application/json"
      {
        "status" => "error",
        "error"  => {
          "code"    => "method_not_allowed",
          "message" => "Requested method not allowed",
        },
      }.to_json
    end
  end
end
