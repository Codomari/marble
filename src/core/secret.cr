require "crypto/bcrypt/password"

module Marble::Core
  class Secret
    class_getter secret_key : String = ""
    class_getter password_cost : Int32 = Crypto::Bcrypt::DEFAULT_COST

    def self.init(
      secret_key : String,
      *,
      password_cost : Int32 = Crypto::Bcrypt::DEFAULT_COST,
    ) : Nil
      raise ArgumentError.new("secret key is required") if secret_key.empty?

      @@secret_key = secret_key
      @@password_cost = password_cost
    end
  end
end
