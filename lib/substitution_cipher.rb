# Common substitution ciphers
module SubstitutionCipher
  # Caesar cipher
  module Caesar
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      int_key = key.to_i
      document.to_s.chars.map do |char|
        ((char.ord + int_key) % 128).chr
      end.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      int_key = key.to_i
      document.to_s.chars.map do |char|
        ((char.ord - int_key) % 128).chr
      end.join
    end
  end

  # Permutation cipher
  module Permutation
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      ords = (0..127).to_a
      mappings = ords.shuffle(random: Random.new(key.to_i))
      document.to_s.chars.map do |char|
        mappings[char.ord].chr
      end.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      ords = (0..127).to_a
      mappings = Hash[ords.shuffle(random: Random.new(key.to_i)).zip(ords)]
      document.to_s.chars.map do |char|
        mappings[char.ord].chr
      end.join
    end
  end
end
