require "json"
require "../lib"

module Marble::Core::Structs
  record ServiceInfo,
    service : String
    do
      def status : String
        "ok"
      end

      def version : String
        Marble::VERSION
      end

      def dependencies : Hash(String, String)
        {} of String => String
      end

      def to_json(json : JSON::Builder) : Nil
        json.object do
          json.field "status", status
          json.field "service", service
          json.field "version", version
          json.field "dependencies", dependencies
        end
      end
    end
end
