require 'json'
require 'openssl'

# AES encrypt / decrypt
module AesCipher
  def self.encrypt(document, key)
    # unpack to bits
    key_length = key.to_s.unpack('B*').join.length
    # number of bits must be 128, 192, or 256
    unless [128, 192, 256].include? key_length
      fail ArgumentError, 'key length must be 128, 192 or 256 bits'
    end
    aes_cipher = OpenSSL::Cipher::AES.new(key_length, :CBC).encrypt
    aes_cipher.key = key
    [
      aes_cipher.random_iv,
      aes_cipher.update(document.to_s) + aes_cipher.final
    ].map { |str| str.unpack('H*').join }.to_json
  end

  def self.decrypt(aes_crypt, key)
    # unpack to bits
    key_length = key.to_s.unpack('B*').join.length
    # number of bits must be 128, 192, or 256
    unless [128, 192, 256].include? key_length
      fail ArgumentError, 'key length must be 128, 192 or 256 bits'
    end
    iv_cipher = JSON.parse(aes_crypt).map { |val| [val].pack('H*') }
    aes_decipher = OpenSSL::Cipher::AES.new(key_length, :CBC).decrypt
    aes_decipher.iv = iv_cipher.first
    aes_decipher.key = key
    aes_decipher.update(iv_cipher.last) + aes_decipher.final
  end
end
