require "../../http/request_handler"

module Marble::Core::Handlers::Errors
  class NotImplemented
    include Marble::Core::HTTP::RequestHandler

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.status_code = 501
      ctx.response.content_type = "application/json"
      {
        "status" => "error",
        "error"  => {
          "code"    => "not_implemented",
          "message" => "Requested resource handler not implemented",
        },
      }.to_json
    end
  end
end
