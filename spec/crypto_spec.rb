require_relative '../lib/credit_card'
require_relative '../lib/substitution_cipher'
require_relative '../lib/double_trans_cipher'
require_relative '../lib/aes_cipher.rb'
require 'minitest/autorun'
require 'securerandom'

# put your crypto modules here
cryptos = [
  {
    method: SubstitutionCipher::Caesar,
    key: Random.rand(20)
  },
  {
    method: SubstitutionCipher::Permutation,
    key: Random.rand(20)
  },
  {
    method: DoubleTranspositionCipher,
    key: Random.rand(20)
  },
  {
    method: AesCipher,
    key: SecureRandom.random_bytes([128, 192, 256].sample / 8)
  }
]

describe 'Test card info encryption' do
  # before each testing
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020', 'S. Ray', 'Visa')
  end
  # test all the crypto methods
  cryptos.each do |crypto|
    describe 'Using #{method}' do
      # test encryption
      it 'should encrypt card information' do
        enc = crypto[:method].encrypt(@cc, crypto[:key])
        enc.wont_equal @cc.to_s
      end
      # test decryption
      it 'should decrypt text' do
        enc = crypto[:method].encrypt(@cc, crypto[:key])
        dec = crypto[:method].decrypt(enc, crypto[:key])
        dec.must_equal @cc.to_s
      end
    end
  end
end
