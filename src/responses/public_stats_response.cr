require "json"

module Marble::Responses
  record PublicStatsResponse do
    def status : String
      "ok"
    end

    def to_json(json : JSON::Builder) : Nil
      json.object do
        json.field "status", status
        json.field "stats" do
          json.object do
            json.field "posts" do
              json.object do
                json.field "total", 0
                json.field "published", 0
              end
            end
          end
        end
      end
    end
  end
end
