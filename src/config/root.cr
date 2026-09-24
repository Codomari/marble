module Marble::Config
  class Root
    getter apps : Hash(String, App)
    getter secret : String
    getter storage : Storage

    def initialize(
      @apps : Hash(String, App),
      @secret : String,
      @storage : Storage,
    )
    end

    def app(name : String) : App
      @apps[name]? || raise ArgumentError.new("missing required config key: apps.#{name}")
    end
  end
end
