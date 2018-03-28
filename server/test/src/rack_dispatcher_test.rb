require_relative 'test_base'
require_relative 'storer_stub'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'FF066'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5D',
  'dispatch to kata_exists' do
    assert_dispatch('kata_exists',
      { kata_id:'1234567890' },
      'false from StorerSpy.kata_exists?'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -


  private

  def assert_dispatch(name, args, stubbed)
    qname = name.end_with?('exists') ? name+'?' : name
    expected = { qname => stubbed }
    rack = RackDispatcher.new(StorerStub.new, RackRequestStub)
    env = { path_info:name, body:args.to_json }

    tuple = rack.call(env)

    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_equal [ expected.to_json ], tuple[2], args
  end

end
