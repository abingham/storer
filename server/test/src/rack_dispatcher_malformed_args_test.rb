require_relative 'test_base'

class RackDispatcherMalformedArgsTest < TestBase

  def self.hex_prefix
    'D6479'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5D', %w( raises when json is malformed ) do
    assert_rack_call_raw('xyz', 'abc', { exception:'json:malformed' })
    assert_rack_call_raw('xyz', '{"x":nil}', { exception:'json:malformed' })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E5E', %w( raises when request name is unknown ) do
    assert_rack_call('xyz', {}, { exception:'json:malformed' })
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # malformed arg on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B3',
  'kata_create raises when manifest is malformed' do
    expected = { exception:'manifest:malformed' }
    malformed_manifests.each do |malformed|
      args = { manifest:malformed }
      assert_rack_call('kata_create', args, expected)
    end
  end

  def malformed_manifests
    bad_time = [2018,-3,28, 11,33,13]
    [
      [],                                              # ! Hash
      {},                                              # required key missing
      bare_manifest.merge({x:'unknown'}),              # unknown key
      bare_manifest.merge({display_name:42}),          # ! String
      bare_manifest.merge({image_name:42}),            # ! String
      bare_manifest.merge({runner_choice:42}),         # ! String
      bare_manifest.merge({visible_files:[]}),         # ! Hash
      bare_manifest.merge({visible_files:{
        'cyber-dojo.sh':42                     # file content must be String
      }}),
      bare_manifest.merge({highlight_filenames:1}),    # ! Array of Strings
      bare_manifest.merge({highlight_filenames:[1]}),  # ! Array of Strings
      bare_manifest.merge({progress_regexs:{}}),       # ! Array of Strings
      bare_manifest.merge({progress_regexs:[1]}),      # ! Array of Strings
      bare_manifest.merge({tab_size:true}),            # ! Integer
      bare_manifest.merge({max_seconds:nil}),          # ! Integer
      bare_manifest.merge({created:nil}),              # ! Array of 6 Integers
      bare_manifest.merge({created:['s']}),            # ! Array of 6 Integers
      bare_manifest.merge({created:bad_time}),         # ! Time
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B4',
  'kata_exists? raises when kata-id is malformed' do
    expected = { exception:'kata_id:malformed' }
    malformed_kata_ids.each do |malformed|
      args = { kata_id:malformed }
      assert_rack_call('kata_exists', args, expected)
    end
  end

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

  def malformed_avatars_names
    [
      nil,       # not an Array
      [],        # empty Array
      [''],      # not a name
      ['blurb'], # not a name
      ['dolpin'] # not a name (dolphin has an H)
    ]
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

  def malformed_avatar_names
    [
      nil,     # not an object
      [],      # not a string
      '',      # not a name
      'blurb', # not a name
      'dolpin' # not a name (dolphin has an H)
    ]
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

  def malformed_tags
    [
      nil,          # not Integer
      [],           # not Integer
      'sunglasses', # not Integer
      '42'          # not Integer
    ]
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

end
