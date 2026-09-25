require "../../../config/root"
require "../../../core/http/request_handler"
require "../../../responses/public_stats_response"

module Marble::Handlers::V1::Public
  class Stats
    private alias Context = ::HTTP::Server::Context
    private alias Config = Marble::Config::Root
    private alias RequestHandler = Marble::Core::HTTP::RequestHandler
    private alias ServiceInfo = Marble::Core::Structs::ServiceInfo
    private alias PublicStatsResponse = Marble::Responses::PublicStatsResponse

    include RequestHandler

    def initialize(@config : Config)
    end

    def handle(ctx : Context)
      ctx.response.content_type = "application/json"
      PublicStatsResponse.new.to_json
    end
  end
end
