require "../../../config/root"
require "../../../core/http/routing"
require "../../../core/structs/service_info"

require "../../../handlers/health"
require "../../../handlers/service_info"
require "./v1"

module Marble::Apps::Server::Routing
  class Root < Marble::Core::HTTP::Routing
    def initialize(@service_info : Marble::Core::Structs::ServiceInfo, @config : Marble::Config::Root)
    end

    def attach : Nil
      map_not_found Marble::Core::Handlers::Errors::NotFound.new
      map_get "/", Marble::Handlers::ServiceInfo.new(@service_info)
      map_get "/health", Marble::Handlers::Health.new(@service_info)

      V1.new(@service_info, @config).attach # attaching /v1 router
    end
  end
end
