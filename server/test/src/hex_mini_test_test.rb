require_relative 'test_base'

class HexMiniTestTest < TestBase

  def self.hex_prefix
    '898EB'
  end

  # - - - - - - - - - - - - - - - -

  test 'C81',
  'hex_id is available via environment variable' do
    assert_equal '898EBC8100', ENV['CYBER_DOJO_TEST_HEX_ID']
  end

end
