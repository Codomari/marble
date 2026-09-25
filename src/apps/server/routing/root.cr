require "../../../config/root"
require "../../../core/http/routing"
require "../../../core/structs/service_info"

require "../../../core/handlers/errors/method_not_allowed"
require "../../../core/handlers/errors/not_found"
require "../../../core/handlers/assets/favicon"

require "../../../handlers/health"
require "../../../handlers/service_info"
require "./v1"

module Marble::Apps::Server::Routing
  class Root < Marble::Core::HTTP::Routing
    private alias Config = Marble::Config::Root
    private alias ServiceInfo = Marble::Core::Structs::ServiceInfo
    private alias Handlers = Marble::Handlers
    private alias CoreHandlers = Marble::Core::Handlers

    def initialize(@service_info : ServiceInfo, @config : Config)
    end

    def attach : Nil
      map_not_found CoreHandlers::Errors::NotFound.new
      map_method_not_allowed CoreHandlers::Errors::MethodNotAllowed.new

      map_get "/favicon.ico", CoreHandlers::Assets::Favicon.new("assets/favicon.ico")
      map_get "/android-chrome-192x192.png", CoreHandlers::Assets::Favicon.new("assets/android-chrome-192x192.png")
      map_get "/android-chrome-512x512.png", CoreHandlers::Assets::Favicon.new("assets/android-chrome-512x512.png")
      map_get "/apple-touch-icon.png", CoreHandlers::Assets::Favicon.new("assets/apple-touch-icon.png")

      map_get "/", Handlers::ServiceInfo.new(@service_info)
      map_get "/health", Handlers::Health.new(@service_info)

      V1.new(@service_info, @config).attach # attaching /v1 router
    end
  end
end
