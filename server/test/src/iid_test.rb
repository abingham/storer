require_relative 'test_base'

class IidTest < TestBase

  def self.hex_prefix
    '5187E'
  end

  # - - - - - - - - - - - - - - - -

  test '52E',
  'generates Base58 ids' do
    42.times do
      generated = iid
      assert Base58.string?(generated), "Base58.string?(#{generated})"
      assert_equal 10, iid.size
    end
  end

end
