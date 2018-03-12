require 'securerandom'

class Base16

  def self.string(size)
    size.times.map{ letter }.join
  end

  def self.letter
    self.alphabet[index]
  end

  def self.index
    SecureRandom.random_number(alphabet.size)
  end

  def self.letter?(char)
    alphabet.include?(char)
  end

  def self.alphabet
    "0123456789ABCDEF"
  end

end
