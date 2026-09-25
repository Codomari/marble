require "kemal"

require "../middlewares/cors"
require "./app"

module Marble::Core
  abstract class ServiceApp < App
    private alias Cors = Marble::Middlewares::Cors

    def run(args : Array(String) = ARGV) : Nil
      configure_app
      attach_routes
      Kemal.run(args)
    end

    protected def configure_app : Nil
      http = config.app(app_name).http
      raise ArgumentError.new("apps.#{app_name}.http must be enabled") unless http.enabled

      Kemal.config.host_binding = http.host
      Kemal.config.port = http.port

      use Cors.new
    end

    protected abstract def attach_routes : Nil
  end
end
