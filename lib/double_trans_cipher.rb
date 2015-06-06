# Double transposition cipher
module DoubleTranspositionCipher
  def self.gen_divisor(doc_len)
    (doc_len**0.5).to_i.upto(doc_len).each do |num|
      next if doc_len % num != 0
      return num
    end
  end

  def self.gen_mapping(doc_len, divisor, key, reversed = false)
    num_gen = Random.new(key.to_i)
    mapping = (0..doc_len / divisor - 1).to_a.shuffle(random: num_gen)
              .product((0..divisor - 1).to_a.shuffle(random: num_gen))
              .map { |pair| pair.first * divisor + pair.last }
    mapping = Hash[mapping.zip(0..doc_len - 1)] if reversed
    mapping
  end

  def self.encrypt(document, key)
    str = document.to_s
    mapping = gen_mapping(str.length, gen_divisor(str.length), key)
    str.chars.each_with_index.map do |_, index|
      str[mapping[index]]
    end.join
  end

  def self.decrypt(ciphertext, key)
    str = ciphertext.to_s
    mapping = gen_mapping(str.length, gen_divisor(str.length), key, true)
    str.chars.each_with_index.map do |_, index|
      str[mapping[index]]
    end.join
  end
end
