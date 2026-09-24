require "../core/http/request_handler"
require "../core/structs/service_info"

module Marble::Handlers
  class Health
    include Marble::Core::HTTP::RequestHandler

    def initialize(@service_info : Marble::Core::Structs::ServiceInfo)
    end

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.content_type = "application/json"
      @service_info.to_json
    end
  end
end
