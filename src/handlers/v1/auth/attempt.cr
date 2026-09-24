require "json"
require "../../../core/http/request_handler"
require "../../../core/structs/service_info"

module Marble::Handlers::V1::Auth
  class Attempt
    include Marble::Core::HTTP::RequestHandler

    def initialize(@service_info : Marble::Core::Structs::ServiceInfo)
    end

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.content_type = "application/json"
      {
        "status"  => "ok",
        "service" => @service_info.service,
        "action"  => "attempt",
      }.to_json
    end
  end
end
