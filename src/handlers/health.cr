require "../core/http/request_handler"
require "../core/structs/service_info"

module Marble::Handlers
  class Health
    private alias Context = ::HTTP::Server::Context
    private alias RequestHandler = Marble::Core::HTTP::RequestHandler
    private alias ServiceInfo = Marble::Core::Structs::ServiceInfo

    include RequestHandler

    def initialize(@service_info : ServiceInfo)
    end

    def handle(ctx : Context)
      ctx.response.content_type = "application/json"
      @service_info.to_json
    end
  end
end
