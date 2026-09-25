require "base64"
require "crypto/bcrypt/password"
require "openssl/hmac"

module Marble::Core::Generators
  class PasswordHasher
    private alias Bcrypt = Crypto::Bcrypt
    private alias Password = Bcrypt::Password

    pepper : String
    cost : Int32
    digest : OpenSSL::Algorithm

    def initialize(
      @pepper : String,
      @cost : Int32 = Bcrypt::DEFAULT_COST,
      @digest : OpenSSL::Algorithm = OpenSSL::Algorithm::SHA256,
    )
    end

    def hash(password : String) : String
      Password.create(
        peppered_password(password),
        cost: @cost
      ).to_s
    end

    def peppered_password(password : String) : String
      Base64.strict_encode(hmac(password))
    end

    private def hmac(password : String) : Bytes
      OpenSSL::HMAC.digest(@digest, @pepper, password)
    end
  end
end
