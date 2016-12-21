require_relative './storer_test_base'
require_relative './spy_logger'
require_relative './../../src/all_avatar_names'

class HostDiskStorerTest < StorerTestBase

  def self.hex_prefix; 'E4FDA20'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # parent
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '72D',
  "storer's parent object is the test object" do
    assert_equal self, storer.parent
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # path
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '218',
  'path is set to /tmp/katas in docker-compose.yml' do
    assert_equal '/tmp/katas', storer.path
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid_id on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '933',
  'create_kata with invalid or missing manifest[id] raises' do
    manifest = create_manifest
    manifest.delete('id')
    error = assert_raises(ArgumentError) { storer.create_kata(manifest) }
    assert_invalid_kata_id_raises do |invalid_id|
      manifest['id'] = invalid_id
      storer.create_kata(manifest)
    end
  end

  test 'ABC',
  'create_kata with duplicate id raises' do
    manifest = create_manifest
    storer.create_kata(manifest)
    error = assert_raises(ArgumentError) { storer.create_kata(manifest) }
    assert error.message.start_with?('Storer'), error.message
  end

  test 'AC2',
  'kata_manifest(id) with invalid id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.kata_manifest(invalid_id)
    }
  end

  test '965',
  'started_avatars(id) with invalid id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.started_avatars(invalid_id)
    }
  end

  test '5DF',
  'start_avatar(id) with bad id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.start_avatar(invalid_id, [lion])
    }
  end

  test 'D9F',
  'avatar_increments(id) with bad id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_increments(invalid_id, lion)
    }
  end

  test '160',
  'avatar_visible_files(id) with bad id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_visible_files(invalid_id, lion)
    }
  end

  test 'D46',
  'avatar_ran_tests(id) with bad id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      args = []
      args << invalid_id
      args << lion
      args << starting_files
      args << time_now
      args << output
      args << red
      storer.avatar_ran_tests(*args)
    }
  end

  test '917',
  'tag_visible_files(id) with bad id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.tag_visible_files(invalid_id, lion, tag=3)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # bad avatar-name on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B5F',
  'avatar_increments(id, name) with bad name raises' do
    assert_bad_avatar_raises { |valid_id, bad_name|
      storer.avatar_increments(valid_id, bad_name)
    }
  end

  test '679',
  'avatar_visible_files(id, name) with bad name raises' do
    assert_bad_avatar_raises { |valid_id, bad_name|
      storer.avatar_visible_files(valid_id, bad_name)
    }
  end

  test '941',
  'avatar_ran_tests(id, name) with bad name raises' do
    assert_bad_avatar_raises { |valid_id, bad_name|
      args = []
      args << valid_id
      args << bad_name
      args << starting_files
      args << time_now
      args << output
      args << red
      storer.avatar_ran_tests(*args)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # bad tag on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '388',
  'tag_visible_files() with bad tag raises' do
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      storer.tag_visible_files(valid_id, valid_name, bad_tag)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # create_kata
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B99',
  'after create_kata(manifest) manifest can be retrieved' do
    manifest = create_kata
    assert_hash_equal manifest, kata_manifest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # completed
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B65',
  'completed(id=nil) is empty string' do
    assert_equal '', storer.completed(nil)
  end

  test 'D39',
  'completed(id="") is empty string' do
    assert_equal '', storer.completed('')
  end

  test '42E',
  'completed(id) does not complete when id is less than 6 chars in length',
  'because trying to complete from a short id will waste time going through',
  'lots of candidates (on disk) with the likely outcome of no unique result' do
    id = kata_id[0..4]
    assert_equal 5, id.length
    assert_equal id, storer.completed(id)
  end

  test '071',
  'completed(id) unchanged when no matches' do
    id = kata_id
    (0..7).each { |size| assert_equal id[0..size], storer.completed(id[0..size]) }
  end

  test '23B',
  'completed(id) does not complete when 6+ chars and more than one match' do
    uncompleted_id = kata_id[0..5]
    create_kata(uncompleted_id + '234' + '5')
    create_kata(uncompleted_id + '234' + '6')
    assert_equal uncompleted_id, storer.completed(uncompleted_id)
  end

  test '093',
  'completed(id) completes when 6+ chars and 1 match' do
    completed_id = kata_id
    create_kata(completed_id)
    uncompleted_id = completed_id.downcase[0..5]
    assert_equal completed_id, storer.completed(uncompleted_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # completions
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '35C',
  'ids_for(outer) zero matches' do
    assert_equal [], storer.completions('C5')
  end

  test '0D6',
  'ids_for(outer) returns inner-dirs, one match' do
    kata_id = '0D6E4FDA26'
    create_kata(kata_id)
    assert_equal [inner(kata_id)], storer.completions('0D')
  end

  test 'A03',
  'ids_for(outer) returns inner-dirs, two close matches' do
    kata_ids = [ 'A03E4FDA20', 'A03E4FDA21' ]
    kata_ids.each { |id| create_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.completions('A0').sort
  end

  test '7FC',
  'ids_for(outer) returns inner-dirs, three far matches' do
    kata_ids = [ '7FC2034534', '7FD92F11B0', '7F13E86582' ]
    kata_ids.each { |id| create_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.completions('7F').sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # start_avatar
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6B',
  'before starting an avatar none exist' do
    create_kata
    assert_equal [], storer.started_avatars(kata_id)
  end

  test 'F6E',
  'rogue sub-dirs in kata-dir are not reported as avatars' do
    create_kata
    rogue = 'flintstone'
    disk[kata_path + '/' + rogue].make
    assert_equal [rogue], disk[kata_path].each_dir.collect { |name| name }
    assert_equal [], storer.started_avatars(kata_id)
  end

  test 'CBF',
  'avatar_start(not-an-avatar-name) fails' do
    create_kata
    assert_nil storer.start_avatar(kata_id, ['pencil'])
  end

  test 'E0C',
  'after avatar_starts;',
  'avatar has no traffic-lights;',
  "avatar's visible_files are from the kata",
  "avatar's increments already have tag zero" do
    create_kata
    assert_equal lion, storer.start_avatar(kata_id, [lion])
    assert_equal [lion], storer.started_avatars(kata_id)
    assert_hash_equal starting_files, avatar_visible_files(lion)
    assert_hash_equal starting_files, tag_visible_files(lion, tag=0)
    assert_equal [
      'event' => 'created',
      'time' => creation_time,
      'number' => 0
    ], avatar_increments(lion)
  end

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    create_kata
    all_avatar_names.each { |name| disk[avatar_path(name)].make }
    assert_equal all_avatar_names.sort, storer.started_avatars(kata_id).sort
    assert_nil storer.start_avatar(kata_id, all_avatar_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF',
  'after ran_tests() there is one more tag, one more traffic-light;',
  'visible_files are retrievable by implicit current-tag',
  'visible_files are retrievable by explicit git-tag',
  'visible_files do not contain output' do
    create_kata
    storer.start_avatar(kata_id, [lion])
    tag = 0

    storer.avatar_ran_tests(*make_args(starting_files))
    tag = 1

    # traffic-lights
    expected = [
      { 'event' => 'created', 'time' => creation_time, 'number' => 0 },
      { 'colour' => red, 'time' => time_now, 'number' => tag }
    ]
    assert_equal expected, avatar_increments(lion)
    # current tag
    visible_files = avatar_visible_files(lion)
    assert_equal output, visible_files['output'], 'output'
    starting_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
    # by tag
    visible_files = tag_visible_files(lion, tag)
    assert_equal output, visible_files['output'], 'output'
    starting_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -
  # old git-format
  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'C33',
  'katas/5A/0F824303/spider already exists and is in old git format' do
    avatar_path = '/tmp/katas/5A/0F824303/spider'
    avatar_dir = disk[avatar_path]
    assert avatar_dir.exists?
    git_path = avatar_path + '/.git'
    git_dir = disk[git_path]
    assert git_dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'D21',
  'old git-format increments can be retrieved' do
    kata_id = '5A0F824303'
    spider = 'spider'
    rags = storer.avatar_increments(kata_id, spider)
    assert 8, rags.size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '694',
  'old git-format tag-zero visible-files can be retrieved' do
    kata_id = '5A0F824303'
    spider = 'spider'
    files = storer.tag_visible_files(kata_id, spider, tag=0)
    expected_filenames = [
      'cyber-dojo.sh',
      'instructions',
      'README',
      'hiker.feature',
      'hiker.py',
      'hiker_steps.py',
      'output'
    ]
    assert_equal expected_filenames.sort, files.keys.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '765',
  'old git-format tag-non-zero visible-files can be retrieved' do
    kata_id = '5A0F824303'
    spider = 'spider'
    files = storer.tag_visible_files(kata_id, spider, tag=1)
    expected_filenames = [
      'cyber-dojo.sh',
      'instructions',
      'README',
      'hiker.feature',
      'hiker.py',
      'hiker_steps.py',
      'output'
    ]
    assert_equal expected_filenames.sort, files.keys.sort
  end

  private

  def kata_id
    test_id.reverse # reversed so I don't get common outer(id)s
  end

  def lion
    'lion'
  end

  include AllAvatarNames

  def create_manifest(id = kata_id)
    manifest = {}
    manifest['image_name'] = 'cyberdojofoundation/gcc_assert'
    manifest['visible_files'] = starting_files
    manifest['created'] = creation_time
    manifest['id'] = id
    manifest
  end

  def create_kata(id = kata_id)
    manifest = create_manifest(id)
    storer.create_kata(manifest)
    manifest
  end

  def starting_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#include <stdio.h>'
    }
  end

  def make_args(files)
    [ kata_id, lion, files, time_now, output, red ]
  end

  def creation_time
    [2016, 12, 2, 6, 13, 23]
  end

  def time_now
    [2016, 12, 2, 6, 14, 57]
  end

  def output
    'Assertion failed: answer() == 42'
  end

  def red
    'red'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_path(name)
    kata_path + '/' + name
  end

  def kata_path
    storer.path + '/' + outer(kata_id) + '/' + inner(kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def outer(id)
    id[0..1]
  end

  def inner(id)
    id[2..-1]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_hash_equal(expected, actual)
    assert_equal expected.size, actual.size
    expected.each do |symbol,value|
      assert_equal value, actual[symbol.to_s], symbol.to_s
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def invalid_kata_ids
    [
      nil,          # not an object
      [],           # not a string
      '',           # not 10 chars
      '34',         # not 10 chars
      '345',        # not 10 chars
      '123456789',  # not 10 chars
      'ABCDEF123X'  # not 10 hex chars
    ]
  end

  def assert_invalid_kata_id_raises
    invalid_kata_ids.each do |id|
      error = assert_raises(ArgumentError) { yield id }
      assert error.message.start_with?('Storer'), error.message
    end
  end

  def assert_bad_kata_id_raises
    valid_but_no_kata = 'F6316A5C7C'
    (invalid_kata_ids + [ valid_but_no_kata ]).each do |id|
      error = assert_raises(ArgumentError) { yield id }
      assert error.message.start_with?('Storer'), error.message
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_avatar_names
    [ nil, [], '', 'chub' ]
  end

  def assert_bad_avatar_raises
    manifest = create_kata
    bad_avatar_names.each do |avatar_name|
      error = assert_raises(ArgumentError) { yield manifest['id'], avatar_name }
      assert error.message.start_with?('Storer'), error.message
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_tags
    [ nil, [], 'sunglasses', 999 ]
  end

  def assert_bad_tag_raises
    create_kata
    storer.start_avatar(kata_id, [lion])
    bad_tags.each do |bad_tag|
      error = assert_raises(ArgumentError) { yield kata_id, lion, bad_tag }
      assert error.message.start_with?('Storer'), error.message
    end
  end

end
