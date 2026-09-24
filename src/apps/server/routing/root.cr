require "../../../config/config"
require "../../../structs/service_info"
require "../../../core/http/routing"

require "../../../handlers/health"
require "../../../handlers/service_info"
require "./v1"

module Marble::Apps::Server::Routing
  class Root < Core::HTTP::Routing
    def initialize(@service_info : Structs::ServiceInfo, @config : Config)
    end

    def attach : Nil
      map_not_found Handlers::Errors::NotFound.new
      map_get "/", Handlers::ServiceInfo.new(@service_info)
      map_get "/health", Handlers::Health.new(@service_info)

      V1.new(@service_info, @config).attach # attaching /v1 router
    end
  end
end
