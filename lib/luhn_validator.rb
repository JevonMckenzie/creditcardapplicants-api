# Validates credit card numbers
module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    switch  = 1
    sum = 0
    array = (0...5).map { |x| 2 * x } + (0...5).map { |x| 2 * x + 1 }
    num = number.reverse.chars.map(&:to_i)
    num.each do |x|
      sum += ((switch ^= 1) == 1) ? array[x] : x
    end
    sum % 10 == 0
  end
end
