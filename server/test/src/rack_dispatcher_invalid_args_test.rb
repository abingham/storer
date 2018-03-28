require_relative 'test_base'

class RackDispatcherInvalidArgsTest < TestBase

  def self.hex_prefix
    '022B5'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  test '820',
  'kata_exists false' do
    expected = { 'kata_exists?':false }
    args = { kata_id:'1234567890' }
    assert_rack_call('kata_exists', args, expected)
  end

  test '923',
  'katas_completed with well-formed partial_id but no matches' do
    expected = { 'katas_completed':'' }
    args = { partial_id:'123456' }
    assert_rack_call('katas_completed', args, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '819',
  'kata_create returns kata-id when sucessful' do
    tuple = rack_call('kata_create', { manifest:bare_manifest }.to_json)
    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    json = JSON.parse(tuple[2][0])
    assert_equal 'kata_create', json.keys[0], tuple[2]

    kata_id = json['kata_create']
    outer_id = kata_id[0..1]
    inner_id = kata_id[2..-1]
    expected = { 'katas_completions':[ inner_id ] }
    args = { outer_id:outer_id }
    assert_rack_call('katas_completions', args, expected)
  end

end
