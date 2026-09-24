require "crypto/bcrypt/password"
require "../generators/password_hasher"

module Marble::Core::Verifiers
  class PasswordVerifier
    pepper : String

    def initialize(@pepper : String)
    end

    def verify(password : String, hashed_password : String) : Bool
      Crypto::Bcrypt::Password.new(hashed_password).verify(
        Marble::Core::Generators::PasswordHasher.new(@pepper).peppered_password(password)
      )
    rescue Crypto::Bcrypt::Error
      false
    end
  end
end
