require "../../../config/root"
require "../../../core/http/routing"
require "../../../core/structs/service_info"

require "../../../handlers/service_info"
require "../../../handlers/v1/public/stats"
require "../../../handlers/v1/auth/attempt"
require "../../../handlers/v1/auth/destroy"

module Marble::Apps::Server::Routing
  class V1 < Marble::Core::HTTP::Routing
    def initialize(@service_info : Marble::Core::Structs::ServiceInfo, @config : Marble::Config::Root)
    end

    def attach : Nil
      map_get "/v1/info", Marble::Handlers::ServiceInfo.new(@service_info)
      map_get "/v1/public/stats", Marble::Handlers::V1::Public::Stats.new(@config)
      map_post "/v1/auth", Marble::Handlers::V1::Auth::Attempt.new(@service_info)
      map_delete "/v1/auth", Marble::Handlers::V1::Auth::Destroy.new(@service_info)
    end
  end
end
