require_relative './client_test_base'
require_relative './../../src/storer_service_error'

class StorerServiceErrorTest < ClientTestBase

  def self.hex_prefix; 'DCCB6'; end

  test '0DA',
  'StorerServiceError can be raised and remembers its message' do
    begin
      fault = StorerServiceError.new('bad json')
      raise fault
    rescue StandardError => e
      assert_equal 'bad json', e.message
    end
  end

end
