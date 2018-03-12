require_relative 'test_base'
require_relative '../../src/base16'

class Base16Test < TestBase

  def self.hex_prefix
    '580B3'
  end

  test '064', %w(
  alphabet has 16 characters ) do
    assert_equal 16, Base16.alphabet.size
  end

  # - - - - - - - - - - - - - - - - - - -

  test '065', %w(
  char generates all chars in alphabet randomly ) do
    counts = {}
    1000.times do
      char = Base16.char
      counts[char] ||= 0
      counts[char] += 1
    end
    assert_equal 16, counts.keys.size
  end

  # - - - - - - - - - - - - - - - - - - -

  test '066', %w(
  no 6-digit string duplicates in 1000 repeats ) do
    ids = {}
    repeats = 1000
    repeats.times do
      s = Base16.string(6)
      ids[s] ||= 0
      ids[s] += 1
    end
    assert_equal repeats, ids.keys.size
  end

end
