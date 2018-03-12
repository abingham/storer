require 'securerandom'

# Similar to https://en.wikipedia.org/wiki/Base58
# o) includes the digits zero and one.
# o) excludes the letter IO (eye,oh) both lowercase and uppercase

class Base58

  def self.string(size)
    (0...size).map{ char }.join
  end

  def self.char
    alphabet[SecureRandom.random_number(58)]
  end

  def self.alphabet
    @@ALPHABET
  end

  private

  # drops: IO io
  @@ALPHABET = %w{
    0 1 2 3 4 5 6 7 8 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h   j k l m n   p q r s t u v w x y z
  }.join

end
