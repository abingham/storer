require_relative 'test_base'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'FF066'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5D',
  'dispatch to kata_exists' do
    args = { kata_id:'1234567890' }
    expected = { 'kata_exists?' => false }
    assert_rack_call('kata_exists', args, expected)
  end

end
