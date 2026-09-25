require "spec"
require "../../../src/core/generators/password_hasher"
require "../../../src/core/verifiers/password_verifier"

private alias Password = Crypto::Bcrypt::Password
private alias PasswordHasher = Marble::Core::Generators::PasswordHasher
private alias PasswordVerifier = Marble::Core::Verifiers::PasswordVerifier

describe Marble::Core::Verifiers::PasswordVerifier do
  it "verifies a password using the configured pepper" do
    pepper = "test-pepper"
    password = "password"
    hashed_password = PasswordHasher.new(pepper, cost: 4).hash(password)

    PasswordVerifier.new(pepper)
      .verify(password, hashed_password)
      .should be_true
  end

  it "rejects an incorrect password" do
    pepper = "test-pepper"
    hashed_password = PasswordHasher.new(pepper, cost: 4).hash("password")

    PasswordVerifier.new(pepper)
      .verify("wrong-password", hashed_password)
      .should be_false
  end

  it "rejects a hash created with a different pepper" do
    hashed_password = PasswordHasher.new("original-pepper", cost: 4).hash("password")

    PasswordVerifier.new("different-pepper")
      .verify("password", hashed_password)
      .should be_false
  end

  it "returns false for an invalid bcrypt hash" do
    PasswordVerifier.new("test-pepper")
      .verify("password", "not-a-bcrypt-hash")
      .should be_false
  end
end
