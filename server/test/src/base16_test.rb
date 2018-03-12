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
  char generates all letters in alphabet randomly ) do
    counts = {}
    1000.times do
      letter = Base16.letter
      counts[letter] ||= 0
      counts[letter] += 1
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

  # - - - - - - - - - - - - - - - - - - -

  test '067', %w(
  index generates 0..15 randomly ) do
    1000.times do
      index = Base16.index
      assert index >= 0, index
      assert index < 16, index
    end
  end

  # - - - - - - - - - - - - - - - - - - -

  test '068', %w(
  letter?(char) true/false ) do
    assert letter?('0')
    assert letter?('1')
    assert letter?('2')
    assert letter?('3')
    assert letter?('4')
    assert letter?('5')
    assert letter?('6')
    assert letter?('7')
    assert letter?('8')
    assert letter?('9')
    assert letter?('A')
    assert letter?('B')
    assert letter?('C')
    assert letter?('D')
    assert letter?('E')
    assert letter?('F')

    refute letter?('a')
    refute letter?('b')
    refute letter?('c')
    refute letter?('d')
    refute letter?('e')
    refute letter?('f')
    refute letter?('g')
    refute letter?('G')
    refute letter?('Z')
    refute letter?('o') # oh
    refute letter?('O') # oh
    refute letter?('i') # eye
    refute letter?('I') # eye
    refute letter?('a')
    refute letter?('z')
  end

  private

  def letter?(char)
    Base16.letter?(char)
  end

end
