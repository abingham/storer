require_relative 'test_base'
require_relative 'storer_stub'
require_relative 'rack_request_stub'
require_relative '../../src/rack_dispatcher'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'FF066'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5A',
  'dispatch raises when method name is unknown' do
    assert_dispatch_raises('unknown',
      {},
      400,
      'ClientError',
      'json:malformed')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5B',
  'dispatch raises when any argument is malformed' do
    assert_dispatch_raises('kata_increments',
      { kata_id:malformed_kata_id },
      500,
      'ArgumentError',
      'kata_id:malformed'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5C',
  'dispatch to kata_create' do
    assert_dispatch('kata_create',
      { manifest:bare_manifest },
      'hello from StorerStub.kata_create'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5D',
  'dispatch to kata_exists' do
    assert_dispatch('kata_exists',
      { kata_id:well_formed_kata_id },
      'hello from StorerStub.kata_exists?'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5E',
  'dispatch to kata_manifest' do
    assert_dispatch('kata_manifest',
      { kata_id:well_formed_kata_id },
      'hello from StorerStub.kata_manifest'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5F',
  'dispatch to kata_increments' do
    assert_dispatch('kata_increments',
      { kata_id:well_formed_kata_id},
      'hello from StorerStub.kata_increments'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E60',
  'dispatch to katas_completed' do
    assert_dispatch('katas_completed',
      { partial_id:well_formed_partial_id},
      'hello from StorerStub.katas_completed'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E61',
  'dispatch to katas_completion' do
    assert_dispatch('katas_completions',
      { outer_id:well_formed_outer_id},
      'hello from StorerStub.katas_completions'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E62',
  'dispatch to avatar_start' do
    assert_dispatch('avatar_start',
      { kata_id:well_formed_kata_id,
        avatars_names: [ 'lion', 'salmon' ]
      },
      'hello from StorerStub.avatar_start'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E63',
  'dispatch to avatars_started' do
    assert_dispatch('avatars_started',
      { kata_id:well_formed_kata_id },
      'hello from StorerStub.avatars_started'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E64',
  'dispatch to avatar_exists' do
    assert_dispatch('avatar_exists',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name
      },
      'hello from StorerStub.avatar_exists?'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E65',
  'dispatch to avatar_increments' do
    assert_dispatch('avatar_increments',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name
      },
      'hello from StorerStub.avatar_increments'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E66',
  'dispatch to avatar_visible_files' do
    assert_dispatch('avatar_visible_files',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name
      },
      'hello from StorerStub.avatar_visible_files'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E67',
  'dispatch to avatar_ran_tests' do
    assert_dispatch('avatar_ran_tests',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name,
        files:well_formed_files,
        now:well_formed_now,
        stdout:well_formed_stdout,
        stderr:well_formed_stderr,
        colour:well_formed_colour
      },
      'hello from StorerStub.avatar_ran_tests'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E68',
  'dispatch to tag_fork' do
    assert_dispatch('tag_fork',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name,
        tag:well_formed_tag,
        now:well_formed_now
      },
      'hello from StorerStub.tag_fork'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E69',
  'dispatch to tag_visible_files' do
    assert_dispatch('tag_visible_files',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name,
        tag:well_formed_tag
      },
      'hello from StorerStub.tag_visible_files'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E70',
  'dispatch to tags_visible_files' do
    assert_dispatch('tags_visible_files',
      { kata_id:well_formed_kata_id,
        avatar_name:well_formed_avatar_name,
        was_tag:well_formed_was_tag,
        now_tag:well_formed_now_tag
      },
      'hello from StorerStub.tags_visible_files'
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E71',
  'dispatch to sha' do
    assert_dispatch('sha', {},
      'hello from StorerStub.sha'
    )
  end

  private

  def malformed_kata_id
    '==' # ! Base58 String
  end

  def well_formed_kata_id
    '1234567890'
  end

  def well_formed_partial_id
    '123456'
  end

  def well_formed_outer_id
    '12'
  end

  def well_formed_avatar_name
    'lion'
  end

  def well_formed_files
    { 'cyber-dojo.sh' => 'make' }
  end

  def well_formed_now
    [2018,3,28, 21,11,39]
  end

  def well_formed_stdout
    'tweedle-dee'
  end

  def well_formed_stderr
    'tweedle-dum'
  end

  def well_formed_colour
    'red'
  end

  def well_formed_tag
    4
  end

  def well_formed_was_tag
    7
  end

  def well_formed_now_tag
    8
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch(name, args, stubbed)
    qname = name.end_with?('exists') ? name+'?' : name
    assert_rack_call(name, args, { qname => stubbed })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch_raises(name, args, status, class_name, message)
    tuple,stderr = with_captured_stderr { rack_call(name, args) }
    assert_equal status, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_exception(tuple[2][0], class_name, message)
    assert_exception(stderr, class_name, message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_exception(s, class_name, message)
    json = JSON.parse(s)
    exception = json['exception']
    refute_nil exception
    assert_equal class_name, exception['class']
    assert_equal message, exception['message']
    assert_equal 'Array', exception['backtrace'].class.name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def with_captured_stderr
    begin
      old_stderr = $stderr
      $stderr = StringIO.new('', 'w')
      tuple = yield
      return [ tuple, $stderr.string ]
    ensure
      $stderr = old_stderr
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call(name, args, expected)
    tuple = rack_call(name, args)
    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_equal [ to_json(expected) ], tuple[2], args
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def rack_call(name, args)
    rack = RackDispatcher.new(StorerStub.new, RackRequestStub)
    env = { path_info:name, body:args.to_json }
    rack.call(env)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def to_json(o)
    JSON.pretty_generate(o)
  end

end
