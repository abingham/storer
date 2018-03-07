require_relative 'test_base'

class UniqueIdTest < TestBase

  def self.hex_prefix
    'ED2BFB'
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '021',
  'its a string' do
    assert_equal 'String', unique_id.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'C4B',
  'it is 10 chars long' do
    (0..25).each do
      assert_equal 10, unique_id.length
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'E40',
  'it contains only [A-E 0-9] characters' do
    (0..25).each do |n|
      id = unique_id
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

  private

  include UniqueId

end
