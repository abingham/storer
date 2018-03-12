require_relative 'test_base'
require_relative '../../src/base58'

class Base58Test < TestBase

  def self.hex_prefix
    'F3A59'
  end

  test '064', %w(
  alphabet has 58 characters ) do
    assert_equal 58, Base58.alphabet.size
  end

  # - - - - - - - - - - - - - - - - - - -

  test '065', %w(
  char generates all chars in alphabet randomly ) do
    counts = {}
    10000.times do
      char = Base58.char
      counts[char] ||= 0
      counts[char] += 1
    end
    assert_equal 58, counts.keys.size
  end

  # - - - - - - - - - - - - - - - - - - -

  test '066', %w(
  at most one 6-digit string duplicate in 100,000 repeats ) do
    ids = {}
    repeats = 100000
    repeats.times do
      s = Base58.string(6)
      ids[s] ||= 0
      ids[s] += 1
    end
    assert (repeats - ids.keys.size) <= 1
  end

end
