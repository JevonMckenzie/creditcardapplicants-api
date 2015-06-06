require_relative '../lib/credit_card'
require 'minitest/autorun'
require 'yaml'

cards = YAML.load_file 'spec/test_numbers.yml'

cards.each do |network, states|
  describe "Works on all #{network} cards" do
    states.each do |state, numbers|
      it "tests all #{state} numbers" do
        numbers.each do |number|
          card = CreditCard.new(number, nil, nil, nil)
          card.validate_checksum.must_equal(state == 'valid')
        end
      end
    end
  end
end
