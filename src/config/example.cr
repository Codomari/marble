require "./config"

module Marble::Config
  class Example
    CONTENT = {{ read_file("#{__DIR__}/../../configs/config.example.yaml") }}
  end
end
