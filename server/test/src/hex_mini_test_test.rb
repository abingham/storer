require_relative 'storer_test_base'

class HexMiniTestTest < StorerTestBase

  def self.hex_prefix; '898'; end

  test 'C80',
  'hex_id is available via environment variable' do
    assert_equal '898C80', ENV['CYBER_DOJO_TEST_HEX_ID']
  end

end
