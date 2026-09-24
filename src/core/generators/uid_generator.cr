require "digest/sha256"

module Marble::Core::Generators
  class UIDGenerator
    # 34^5 = 45,435,424
    HALF_MAX = 45_435_424_i64
    MAX_VAL  = HALF_MAX * HALF_MAX # 2,064,377,754,059,776 (~2 Quadrillion)

    CHARS = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"
    CODE_LENGTH = 10

    @key_hash : UInt64

    def initialize(seed : String)
      hash_bytes = Digest::SHA256.digest(seed)
      @key_hash = IO::ByteFormat::BigEndian.decode(UInt64, hash_bytes.to_slice[0, 8])
    end

    def generate(seq_num : Int) : String
      seq_i64 = seq_num.to_i64
      raise ArgumentError.new("Sequential number exceeds 10-character limit.") if seq_i64 >= MAX_VAL
      raise ArgumentError.new("Sequential number cannot be negative.") if seq_i64 < 0

      scrambled = obfuscate(seq_i64)
      to_base34(scrambled)
    end

    def decode(code : String) : Int64
      raise ArgumentError.new("Code must be exactly #{CODE_LENGTH} characters.") if code.bytesize != CODE_LENGTH

      cleaned_code = code.upcase.tr("OI", "01")

      scrambled = from_base34(cleaned_code)
      de_obfuscate(scrambled)
    end

    private def round_function(val : Int64, round_num : Int32) : Int64
      ((val.to_u64 ^ round_num.to_u64 ^ @key_hash) % HALF_MAX.to_u64).to_i64
    end

    private def obfuscate(num : Int64) : Int64
      left = num // HALF_MAX
      right = num % HALF_MAX

      4.times do |i|
        temp = right
        right = (left + round_function(right, i)) % HALF_MAX
        left = temp
      end

      left * HALF_MAX + right
    end

    private def de_obfuscate(num : Int64) : Int64
      left = num // HALF_MAX
      right = num % HALF_MAX

      3.downto(0) do |i|
        temp = left
        left = (right - round_function(left, i)) % HALF_MAX
        right = temp
      end

      left * HALF_MAX + right
    end

    private def to_base34(num : Int64) : String
      return "0" * CODE_LENGTH if num == 0

      String.build(CODE_LENGTH) do |str|
        current = num
        while current > 0
          str << CHARS[current % 34]
          current //= 34
        end
      end.reverse.rjust(CODE_LENGTH, '0')
    end

    private def from_base34(code : String) : Int64
      result = 0_i64
      code.each_char do |char|
        idx = CHARS.index(char)
        raise ArgumentError.new("Invalid character in code: #{char}") unless idx
        result = result * 34 + idx
      end
      result
    end
  end
end
