require "../../../config/root"
require "../../../core/http/routing"
require "../../../core/structs/service_info"

require "../../../handlers/service_info"
require "../../../handlers/v1/public/stats"
require "../../../handlers/v1/auth/attempt"
require "../../../handlers/v1/auth/destroy"

module Marble::Apps::Server::Routing
  class V1 < Marble::Core::HTTP::Routing
    private alias Config = Marble::Config::Root
    private alias ServiceInfo = Marble::Core::Structs::ServiceInfo
    private alias Handlers = Marble::Handlers

    def initialize(@service_info : ServiceInfo, @config : Config)
    end

    def attach : Nil
      map_get "/v1/info", Handlers::ServiceInfo.new(@service_info)
      map_get "/v1/public/stats", Handlers::V1::Public::Stats.new(@config)
      map_post "/v1/auth", Handlers::V1::Auth::Attempt.new(@service_info)
      map_delete "/v1/auth", Handlers::V1::Auth::Destroy.new(@service_info)
    end
  end
end
