require "spec"
require "../../../src/core/generators/password_hasher"

private alias Password = Crypto::Bcrypt::Password
private alias PasswordHasher = Marble::Core::Generators::PasswordHasher

describe Marble::Core::Generators::PasswordHasher do
  it "supports a custom digest when peppering a password" do
    digest = OpenSSL::Algorithm::SHA512
    hasher = PasswordHasher.new("pepper", cost: 5, digest: digest)

    peppered_password = hasher.peppered_password("password")

    peppered_password.should_not be_empty
    peppered_password.should_not eq("password")
    peppered_password.should eq(hasher.peppered_password("password"))
  end

  it "pepper-hashes a password with the configured pepper" do
    hasher = PasswordHasher.new("test-pepper")

    peppered_password = hasher.peppered_password("password")

    peppered_password.should_not be_empty
    peppered_password.should_not eq("password")
    peppered_password.should_not eq(
      PasswordHasher
        .new("other-pepper")
        .peppered_password("password")
    )
  end

  it "returns a bcrypt hash that verifies the peppered password" do
    hasher = PasswordHasher.new("test-pepper", cost: 4)
    hashed_password = hasher.hash("password")

    Password.new(hashed_password).verify(
      hasher.peppered_password("password")
    ).should be_true
    Password.new(hashed_password).verify(
      hasher.peppered_password("wrong-password")
    ).should be_false
  end
end
