module Marble
  class Config
    getter apps : Hash(String, Config::App)
    getter database : Config::Database
    getter redis : Config::Redis
    getter secret : String
    getter storage : Config::Storage

    def initialize(
      @apps : Hash(String, Config::App),
      @database : Config::Database,
      @redis : Config::Redis,
      @secret : String,
      @storage : Config::Storage,
    )
    end

    def app(name : String) : Config::App
      @apps[name]? || raise ArgumentError.new("missing required config key: apps.#{name}")
    end
  end
end
