require_relative 'test_base'

class WellFormedArgsTest < TestBase

  def self.hex_prefix
    '0A0C4'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # c'tor
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A04',
  'ctor raises when its string arg is not valid json' do
    expected = 'json:malformed'
    # abc is not a valid top-level json element
    error = assert_raises { WellFormedArgs.new('abc') }
    assert_equal expected, error.message
    # nil is null in json
    error = assert_raises { WellFormedArgs.new('{"x":nil}') }
    assert_equal expected, error.message
    # keys have to be strings in json
    error = assert_raises { WellFormedArgs.new('{42:"answer"}') }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # manifest
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '591',
  'manifest does not raise when well-formed' do
    manifest = bare_manifest
    json = { manifest:manifest }.to_json
    assert_equal manifest, WellFormedArgs.new(json).manifest
  end

  test '592',
  'manifest raises when malformed' do
    malformed_manifests.each do |malformed|
      json = { manifest:malformed }.to_json
      error = assert_raises {
        WellFormedArgs.new(json).manifest
      }
      assert_equal 'manifest:malformed', error.message
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
      bare_manifest.merge({filename_extension:true}),  # ! String
      bare_manifest.merge({exercise:true}),            # ! String
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
  # outer_id
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C6B',
  'outer_id does not raise when well-formed' do
    outer_id = '12'
    json = { outer_id:outer_id }.to_json
    assert_equal outer_id, WellFormedArgs.new(json).outer_id
  end

  test 'CB7',
  'outer_id raises when malformed' do
    expected = 'outer_id:malformed'
    malformed_outer_ids.each do |malformed|
      json = { outer_id:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.outer_id }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_outer_ids
    [
      true,  # ! String
      '=',   # ! Base58 String
      '123', # ! length 2
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # partial_id
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'FC1',
  'partial_id does not raise when well-formed' do
    partial_id = '1a34Z6'
    json = { partial_id:partial_id }.to_json
    assert_equal partial_id, WellFormedArgs.new(json).partial_id
  end

  test 'FC2',
  'partial_id raises when malformed' do
    expected = 'partial_id:malformed'
    malformed_partial_ids.each do |malformed|
      json = { partial_id:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.partial_id }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_partial_ids
    [
      false,    # ! String
      '=',      # ! Base58 String
      'abc'     # ! length 6..10
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_id
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '61A',
  'kata_id does not raise when well-formed' do
    kata_id = 'A1B2F345kn'
    json = { kata_id:kata_id }.to_json
    assert_equal kata_id, WellFormedArgs.new(json).kata_id
  end

  test '61B',
  'kata_id raises when malformed' do
    expected = 'kata_id:malformed'
    malformed_kata_ids.each do |malformed|
      json = { kata_id:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.kata_id }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_kata_ids
    [
      nil,          # ! String
      [],           # ! string
      '',           # ! 10 chars
      '34',         # ! 10 chars
      '345',        # ! 10 chars
      '123456789',  # ! 10 chars
      'ABCDEF123='  # ! Base58 chars
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatars_names
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '442',
  'avatars_names does not raise when well-formed' do
    avatars_names = [ 'lion','salmon' ]
    json = { avatars_names:avatars_names }.to_json
    assert_equal avatars_names, WellFormedArgs.new(json).avatars_names
  end

  test '443',
  'avatars_names raises when malformed' do
    expected = 'avatars_names:malformed'
    malformed_avatars_names.each do |malformed|
      json = { avatars_names:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.avatars_names }
      assert_equal expected, error.message, malformed
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
  # avatar_name
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8AC',
  'avatar_name does not raise when well-formed' do
    avatar_name = 'salmon'
    json = { avatar_name:avatar_name }.to_json
    assert_equal avatar_name, WellFormedArgs.new(json).avatar_name
  end

  test '8AD',
  'avatar_name raises when malformed' do
    expected = 'avatar_name:malformed'
    malformed_avatar_names.each do |malformed|
      json = { avatar_name:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.avatar_name }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_avatar_names
    [
      nil,     # ! String
      [],      # ! String
      '',      # ! avatar-name
      'blurb', # ! avatar-name
      'dolpin' # ! avatar-name (dolphin has an H)
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4A4',
  'tag does not raise when well-formed' do
    tag = 42
    json = { tag:tag }.to_json
    assert_equal tag, WellFormedArgs.new(json).tag
  end

  test '4A5',
  'tag raises when malformed' do
    expected = 'tag:malformed'
    malformed_tags.each do |malformed|
      json = { tag:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.tag }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_tags
    [
      nil,          # ! Integer
      [],           # ! Integer
      'sunglasses', # ! Integer
      '42'          # ! Integer
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # was_tag
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B43',
  'was_tag does not raise when well-formed' do
    was_tag = 2
    json = { was_tag:was_tag }.to_json
    assert_equal was_tag, WellFormedArgs.new(json).was_tag
  end

  test 'B44',
  'was_tag raises when malformed' do
    expected = 'was_tag:malformed'
    malformed_tags.each do |malformed|
      json = { was_tag:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.was_tag }
      assert_equal expected, error.message, malformed
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # now_tag
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C28',
  'now_tag does not raise when well-formed' do
    now_tag = 5
    json = { now_tag:now_tag }.to_json
    assert_equal now_tag, WellFormedArgs.new(json).now_tag
  end

  test 'C29',
  'now_tag raises when malformed' do
    expected = 'now_tag:malformed'
    malformed_tags.each do |malformed|
      json = { now_tag:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.now_tag }
      assert_equal expected, error.message, malformed
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # stdout
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E35',
  'stdout does not raise when well-formed' do
    stdout = 'gsdfg'
    json = { stdout:stdout }.to_json
    assert_equal stdout, WellFormedArgs.new(json).stdout
  end

  test 'E36',
  'stdout raises when malformed' do
    expected = 'stdout:malformed'
    malformed_stdouts.each do |malformed|
      json = { stdout:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.stdout }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_stdouts
    [ nil, true, [1], {} ] # ! String
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # stderr
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8DB',
  'stderr does not raise when well-formed' do
    stderr = 'ponoi'
    json = { stderr:stderr }.to_json
    assert_equal stderr, WellFormedArgs.new(json).stderr
  end

  test '8DC',
  'stderr raises when malformed' do
    expected = 'stderr:malformed'
    malformed_stderrs.each do |malformed|
      json = { stderr:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.stderr }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_stderrs
    [ nil, true, [1], {} ] # ! String
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # files
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '846',
  'files does not raise when well-formed' do
    files = {'cyber-dojo.sh' => 'make' }
    json = { files:files }.to_json
    assert_equal files, WellFormedArgs.new(json).files
  end

  test '847',
  'files raises when malformed' do
    expected = 'files:malformed'
    malformed_files.each do |malformed|
      json = { files:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.files }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_files
    [
      [],              # ! Hash
      { "x" => 42 },   # content ! String
      { "y" => true }, # content ! String
      { "z" => nil },  # content ! String
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # colour
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '041',
  'colour does not raise when well-formed' do
    colours = [ 'red', 'amber', 'green', 'timed_out' ]
    colours.each do |colour|
      json = { colour:colour }.to_json
      assert_equal colour, WellFormedArgs.new(json).colour
    end
  end

  test '042',
  'colour raises when malformed' do
    expected = 'colour:malformed'
    malformed_colours.each do |malformed|
      json = { colour:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.colour }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_colours
    [ nil, true, {}, [], 'RED' ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # now
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'FF4',
  'now does not raise when well-formed' do
    now = [2018,3,28, 19,18,45]
    json = { now:now }.to_json
    assert_equal now, WellFormedArgs.new(json).now
  end

  test 'FF5',
  'now raises when malformed' do
    expected = 'now:malformed'
    malformed_nows.each do |malformed|
      json = { now:malformed }.to_json
      wfa = WellFormedArgs.new(json)
      error = assert_raises { wfa.now }
      assert_equal expected, error.message, malformed
    end
  end

  def malformed_nows
    [
      [], {}, nil, true, 42,
      [2018,-3,28, 19,18,45],
      [2018,3,28, 19,18]
    ]
  end

end



=begin

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

  test '7B7',
  'avatars_started raises when kata_id is malformed' do
    expected = { exception:'kata_id:malformed' }
    args = { kata_id:nil }
    assert_rack_call('avatars_started', args, expected)
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
=end

