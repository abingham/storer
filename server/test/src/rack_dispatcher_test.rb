require_relative '../../src/rack_dispatcher'
require_relative 'rack_request_stub'
require_relative 'test_base'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'D6479'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5C', %w( raises when request name is unknown ) do
    assert_rack_call('xyz', {}, { exception:'unknown-method' })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5D', %w( raises when json is malformed ) do
    assert_rack_call_raw('xyz', 'abc', { exception:'!json' })
    assert_rack_call_raw('xyz', '{"x":nil}', { exception:'!json' })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # malformed arg on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def malformed_manifests
    [
      [],                                 # not a Hash
      { 'runner_choice':42 },             # value not a string
      { 'runner_choice':'stateless' },    # required key missing
    ]
  end

  test '6B3',
  'kata_create raises when manifest is malformed' do
    expected = { exception:'manifest:malformed' }
    malformed_manifests.each do |malformed|
      args = { manifest:malformed }
      assert_rack_call('kata_create', args, expected)
    end
  end

  test '6B4',
  'kata_exists? raises when kata-id is malformed' do
    expected = { exception:'kata_id:malformed' }
    malformed_kata_ids.each do |malformed|
      args = { kata_id:malformed }
      assert_rack_call('kata_exists', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B5',
  'katas_completed raises when partial_id is malformed' do
    expected = { exception:'partial_id:malformed' }
    args = { partial_id:nil }
    assert_rack_call('katas_completed', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B6',
  'katas_completions raises when outer_id is malformed' do
    expected = { exception:'outer_id:malformed' }
    args = { outer_id:nil }
    assert_rack_call('katas_completions', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B7',
  'avatar_start raises when avatar_names is malformed' do
    expected = { exception:'avatars_names:malformed' }
    malformed_avatars_names.each do |malformed|
      args = {
        kata_id:'1234567890',
        avatars_names:malformed
      }
      assert_rack_call('avatar_start', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B8',
  'avatar_exists? raises when avatar-name is malformed' do
    expected = { exception:'avatar_name:malformed' }
    malformed_avatar_names.each do |malformed|
      args = {
        kata_id:'1234567890',
        avatar_name:malformed
      }
      assert_rack_call('avatar_exists', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B9',
  'tag_fork raises when tag is malformed' do
    expected = { exception:'tag:malformed' }
    malformed_tags.each do |malformed|
      args = {
        kata_id:'1234567890',
        avatar_name:'salmon',
        tag:malformed
      }
      assert_rack_call('tag_fork', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BA',
  'tags_visible_files raises when was_tag is malformed' do
    expected = { exception:'was_tag:malformed' }
    malformed_tags.each do |malformed|
      args = {
        kata_id:'1234567890',
        avatar_name:'salmon',
        was_tag:malformed,
        now_tag:23
      }
      assert_rack_call('tags_visible_files', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BB',
  'tags_visible_files raises when now_tag is malformed' do
    expected = { exception:'now_tag:malformed' }
    malformed_tags.each do |malformed|
      args = {
        kata_id:'1234567890',
        avatar_name:'salmon',
        was_tag:23,
        now_tag:malformed
      }
      assert_rack_call('tags_visible_files', args, expected)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BC',
  'avatar_ran_tests raises when stdout is malformed' do
    expected = { exception:'stdout:malformed' }
    args = avatar_ran_tests_args
    args[:stdout] = nil
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BD',
  'avatar_ran_tests raises when stderr is malformed' do
    expected = { exception:'stderr:malformed' }
    args = avatar_ran_tests_args
    args[:stderr] = nil
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BE',
  'avatar_ran_tests raises when files is malformed' do
    expected = { exception:'files:malformed' }
    args = avatar_ran_tests_args
    args[:files] = nil
    assert_rack_call('avatar_ran_tests', args, expected)
    args[:files] = { 's' => 34 }
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6BF',
  'avatar_ran_tests raises when colour is malformed' do
    expected = { exception:'colour:malformed' }
    args = avatar_ran_tests_args
    args[:colour] = nil
    assert_rack_call('avatar_ran_tests', args, expected)
    args[:colour] = 42
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6C0',
  'avatar_ran_tests raises when now is malformed' do
    expected = { exception:'now:malformed' }
    args = avatar_ran_tests_args
    args[:now] = nil
    assert_rack_call('avatar_ran_tests', args, expected)
    args[:now] = [2018,3,27, 13,43,-45]
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid arg on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '820',
  'kata_exists raises when kata_id is invalid' do
    expected = { 'kata_exists?':false }
    args = { kata_id:'1234567890' }
    assert_rack_call('kata_exists', args, expected)
  end

  test '821',
  'kata_manifest raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890' }
    assert_rack_call('kata_manifest', args, expected)
  end

  test '822',
  'kata_increments raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890' }
    assert_rack_call('kata_increments', args, expected)
  end

  test '823',
  'avatar_start raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890', avatars_names:['lion'] }
    assert_rack_call('avatar_start', args, expected)
  end

  test '824',
  'avatars_started raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890' }
    assert_rack_call('avatars_started', args, expected)
  end

  test '825',
  'tag_visible_files raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890', avatar_name:'lion', tag:12 }
    assert_rack_call('tag_visible_files', args, expected)
  end

  test '826',
  'tags_visible_files raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = { kata_id:'1234567890', avatar_name:'lion', was_tag:1, now_tag:2 }
    assert_rack_call('tags_visible_files', args, expected)
  end

  test '827',
  'avatar_ran_tests raises when kata_id is invalid' do
    expected = { exception:'kata_id:invalid' }
    args = avatar_ran_tests_args
    assert_rack_call('avatar_ran_tests', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '923',
  'katas_completed with well-formed partial_id but no matches' do
    expected = { 'katas_completed':'' }
    args = { partial_id:'123456' }
    assert_rack_call('katas_completed', args, expected)
  end

  test '924',
  'katas_completions with well-formed outer_id but no matches' do
    expected = { 'katas_completions':[] }
    args = { outer_id:'12' }
    assert_rack_call('katas_completions', args, expected)
  end

  private # = = = = = = = = = = = = = = = = = = = = = =

  def avatar_ran_tests_args
    {
      kata_id:'1234567890',
      avatar_name:'lion',
      files: { 'cyber-dojo.sh' => 'make' },
      now: [2018,3,27, 9,58,01],
      stdout:'tweedle-dee',
      stderr:'tweedle-dum',
      colour:'red'
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def malformed_kata_ids
    [
      nil,          # not an object
      [],           # not a string
      '',           # not 10 chars
      '34',         # not 10 chars
      '345',        # not 10 chars
      '123456789',  # not 10 chars
      'ABCDEF123='  # not Base58 chars
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def malformed_avatars_names
    [
      nil,       # not an Array
      [],        # empty Array
      [''],      # not a name
      ['blurb'], # not a name
      ['dolpin'] # not a name (dolphin has an H)
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def malformed_avatar_names
    [
      nil,     # not an object
      [],      # not a string
      '',      # not a name
      'blurb', # not a name
      'dolpin' # not a name (dolphin has an H)
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def malformed_tags
    [
      nil,          # not Integer
      [],           # not Integer
      'sunglasses', # not Integer
      '42'          # not Integer
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call(path_info, args, expected)
    assert_rack_call_raw(path_info, args.to_json, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call_raw(path_info, args, expected)
    tuple = rack_call(path_info, args)
    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_equal [ expected.to_json ], tuple[2]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def rack_call(path_info, args)
    refute path_info.end_with?('?'), 'http drops trailing ?'
    rack = RackDispatcher.new(RackRequestStub)
    env = { path_info:path_info, body:args }
    rack.call(env)
  end

end
