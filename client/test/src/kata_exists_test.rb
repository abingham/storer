require_relative './client_test_base'

class KataExistsTest < ClientTestBase

  def self.hex_prefix; '6AA1B'; end

  test 'E98',
  'kata_exists() for a kata_id that is not a 10-digit hex-string is false' do
    kata_exists?('123')
    assert_status false
  end

end
