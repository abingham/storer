require_relative 'test_base'

class IdGeneratorTest < TestBase

  def self.hex_prefix
    '9E748'
  end

  # - - - - - - - - - - - - - - - -

  test '926',
  'generates raw kata-ids' do
    id = id_generator.generate
    assert_equal 'String', id.class.name
    assert_equal 10, id.size
    42.times do
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

end
