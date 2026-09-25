require "crypto/bcrypt/password"
require "../generators/password_hasher"

module Marble::Core::Verifiers
  class PasswordVerifier
    private alias Bcrypt = Crypto::Bcrypt
    private alias Password = Bcrypt::Password
    private alias PasswordError = Bcrypt::Error
    private alias PasswordHasher = Marble::Core::Generators::PasswordHasher

    pepper : String

    def initialize(@pepper : String)
    end

    def verify(password : String, hashed_password : String) : Bool
      Password.new(hashed_password).verify(
        PasswordHasher.new(@pepper).peppered_password(password)
      )
    rescue PasswordError
      false
    end
  end
end
