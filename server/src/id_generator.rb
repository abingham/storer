require 'securerandom'

class IdGenerator

  def generate
    (0...10).map{ random_char }.join
  end

  private

  def random_char
    index = SecureRandom.random_number(HEX_CHAR_SET.size)
    HEX_CHAR_SET[index]
  end

  # 6 hex digits are completed to 10 and
  # 6 hex digits gives 16^6 == 16,777,216
  # which is not enough.

  HEX_CHAR_SET = %w{
    0 1 2 3 4 5 6 7 9
    A B C D E F
  }.to_a

  # Base 60 is like Base58 https://en.wikipedia.org/wiki/Base58
  # but it includes the digits zero and one.
  # This is to make it a superset of hex to keep backward compatibility.
  # 6 Base60 digits gives 60^6 == 46,656,000,000
  # which is enough.
  BASE_60_CHAR_SET = %w{
    0 1 2 3 4 5 6 7 9
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
    a b c d e f g h   j k l m n   p q r s t u v w x y z
  }.to_a

end
