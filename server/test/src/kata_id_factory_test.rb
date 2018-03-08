require_relative 'test_base'

class KataIdFactoryTest < TestBase

  def self.hex_prefix
    '9E748'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test '926',
  'id-factory produces kata-ids' do
    id = id_factory.id
    assert_equal 'String', id.class.name
  end

  private

end
