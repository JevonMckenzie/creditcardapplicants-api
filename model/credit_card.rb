require 'json'
require 'base64'
require 'openssl'
require 'sinatra/activerecord'
require 'rbnacl/libsodium'
require_relative '../environments.rb'
require_relative '../lib/luhn_validator.rb'

# Credit card entity
class CreditCard < ActiveRecord::Base
  # Mixin the validator
  include LuhnValidator

  # instance variables with automatic getter/setter methods
  # attr_accessor :number, :expiration_date, :owner, :credit_network
  #
  # def initialize(number, expiration_date, owner, credit_network)
  #   @number = number
  #   @expiration_date = expiration_date
  #   @owner = owner
  #   @credit_network = credit_network
  # end

  # return a hash of the serialized credit card object
  def to_hash
    {
      number: number,
      expiration_date: expiration_date,
      owner: owner,
      credit_network: credit_network
    }
  end

  # returns json string
  def to_json
    to_hash.to_json
  end

  # returns all card information as single string
  def to_s
    to_json
  end

  # return a new CreditCard object given a serialized (JSON) representation
  def self.from_s(card_s)
    card = JSON.parse(card_s)
    CreditCard.new(card['number'], card['expiration_date'],
                   card['owner'], card['credit_network'])
  end

  # return a cryptographically secure hash
  def hash_secure
    OpenSSL::Digest::SHA256.new.digest(to_json).unpack('H*').first
  end

  def secret_box
    @secret_box ||= RbNaCl::SecretBox.new(Base64.urlsafe_decode64(ENV['DB_KEY']))
  end

  # number getter
  def number
    nonce_bytes = Base64.urlsafe_decode64(nonce)
    encrypted_number_bytes = Base64.urlsafe_decode64(encrypted_number)
    secret_box.decrypt(nonce_bytes, encrypted_number_bytes)
  end

  # number setter
  def number=(plain)
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    self.nonce = Base64.urlsafe_encode64(nonce)
    self.encrypted_number = Base64.urlsafe_encode64(secret_box.encrypt(nonce, plain))
  end
end
