require_relative 'test_base'

class KataIdFactoryTest < TestBase

  def self.hex_prefix
    '9E748'
  end

  # - - - - - - - - - - - - - - - -

  test '926',
  'id-factory produces kata-ids' do
    id = id_factory.id
    assert_equal 'String', id.class.name
    assert_equal 10, id.size
    (0..25).each do
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

  # - - - - - - - - - - - - - - - -

  test '927',
  '' do
  end

  private

end
