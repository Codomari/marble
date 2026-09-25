require "spec"
require "../../../src/core/generators/uid_generator"

private alias UIDGenerator = Marble::Core::Generators::UIDGenerator

describe Marble::Core::Generators::UIDGenerator do
  describe "#generate and #decode" do
    it "generates a ten-character UID and decodes it back to the sequence number" do
      generator = UIDGenerator.new("test-seed")
      sequence_number = 123_456_i64

      uid = generator.generate(sequence_number)

      uid.size.should eq(10)
      generator.decode(uid).should eq(sequence_number)
    end

    it "supports zero as a sequence number" do
      generator = UIDGenerator.new("test-seed")

      uid = generator.generate(0)

      uid.size.should eq(10)
      generator.decode(uid).should eq(0)
    end

    it "handles boundary value (MAX_VAL - 1)" do
      generator = UIDGenerator.new("test-seed")
      max_seq = UIDGenerator::MAX_VAL - 1_i64

      uid = generator.generate(max_seq)

      uid.size.should eq(10)
      generator.decode(uid).should eq(max_seq)
    end

    it "normalizes 'O' and 'I' characters during decode" do
      generator = UIDGenerator.new("test-seed")

      # Generate a valid UID, then swap valid chars to test 'O' and 'I' replacement logic
      code_with_o_i = "00000000OI"
      normalized_code = "0000000001"

      generator.decode(code_with_o_i)
        .should eq(generator.decode(normalized_code))
    end
  end

  describe "determinism and seed isolation" do
    it "generates deterministic UIDs for the same seed and sequence number" do
      first_generator = UIDGenerator.new("test-seed")
      second_generator = UIDGenerator.new("test-seed")

      first_generator.generate(42)
        .should eq(second_generator.generate(42))
    end

    it "generates different UIDs for different seeds" do
      first_generator = UIDGenerator.new("first-seed")
      second_generator = UIDGenerator.new("second-seed")

      first_generator.generate(42)
        .should_not eq(second_generator.generate(42))
    end
  end

  describe "validation & error handling" do
    it "rejects negative sequence numbers" do
      generator = UIDGenerator.new("test-seed")

      expect_raises(ArgumentError, "Sequential number cannot be negative.") do
        generator.generate(-1)
      end
    end

    it "rejects sequence numbers that equal or exceed MAX_VAL" do
      generator = UIDGenerator.new("test-seed")

      expect_raises(ArgumentError, "Sequential number exceeds 10-character limit.") do
        generator.generate(UIDGenerator::MAX_VAL)
      end
    end

    it "rejects codes with an invalid length" do
      generator = UIDGenerator.new("test-seed")

      expect_raises(ArgumentError, "Code must be exactly 10 characters.") do
        generator.decode("ABC")
      end

      expect_raises(ArgumentError, "Code must be exactly 10 characters.") do
        generator.decode("0123456789A") # 11 chars
      end
    end

    it "rejects codes with characters outside the UID alphabet" do
      generator = UIDGenerator.new("test-seed")

      expect_raises(ArgumentError, "Invalid character in code: @") do
        generator.decode("00000000@0")
      end
    end
  end
end
