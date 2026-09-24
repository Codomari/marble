module Marble::Config
  class Storage
    getter root : String
    getter users : String

    def initialize(@root : String, @users : String)
    end
  end
end
