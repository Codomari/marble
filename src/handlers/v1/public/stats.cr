require "../../../config/root"
require "../../../core/http/request_handler"
require "../../../responses/public_stats_response"

module Marble::Handlers::V1::Public
  class Stats
    include Marble::Core::HTTP::RequestHandler

    def initialize(@config : Marble::Config::Root)
    end

    def handle(ctx : ::HTTP::Server::Context)
      ctx.response.content_type = "application/json"
      Marble::Responses::PublicStatsResponse.new.to_json
    end
  end
end
