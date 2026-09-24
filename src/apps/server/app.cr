require "../../core/service_app"
require "./routing/root"

module Marble::Apps::Server
  class App < Marble::Core::ServiceApp
    def initialize(config : Marble::Config? = nil)
      super("server", "marble-server", config)
    end

    protected def attach_routes : Nil
      Routing::Root.new(service_info, config).attach
    end
  end
end
