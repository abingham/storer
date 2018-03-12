require 'securerandom'

class Base16

  def self.string(size)
    size.times.map{ self.char }.join
  end

  def self.char
    self.alphabet[SecureRandom.random_number(16)]
  end

  def self.alphabet
    "0123456789ABCDEF"
  end

end
