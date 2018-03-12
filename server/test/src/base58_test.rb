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
  char generates all letters in alphabet randomly ) do
    counts = {}
    10000.times do
      letter = Base58.letter
      counts[letter] ||= 0
      counts[letter] += 1
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

  # - - - - - - - - - - - - - - - - - - -

  test '067', %w(
  index generates 0..57 randomly ) do
    1000.times do
      index = Base58.index
      assert index >= 0, index
      assert index < 58, index
    end
  end

  # - - - - - - - - - - - - - - - - - - -

  test '068', %w(
  letter?(char) true/false ) do
    assert letter?('0')
    assert letter?('1')
    assert letter?('9')
    assert letter?('a')
    assert letter?('z')
    assert letter?('A')
    assert letter?('Z')
    refute letter?('o') # oh
    refute letter?('O') # oh
    refute letter?('i') # eye
    refute letter?('I') # eye
  end

  private

  def letter?(char)
    Base58.letter?(char)
  end

end
