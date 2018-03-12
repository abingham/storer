require 'securerandom'

class Base16

  def self.string(size)
    size.times.map{ char }.join
  end

  def self.char
    self.alphabet[index]
  end

  def self.index
    SecureRandom.random_number(alphabet.size)
  end

  def self.alphabet
    "0123456789ABCDEF"
  end

end
