require_relative 'test_base'
require_relative 'spy_logger'
require_relative '../../src/all_avatars_names'

class StorerTest < TestBase

  def self.hex_prefix
    'E4FDA20'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # path
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '218',
  'path is set to ENV[CYBER_DOJO_KATAS_ROOT] from docker-compose.yml' do
    assert_equal cyber_dojo_katas_root, storer.path
    assert_equal '/tmp/cyber-dojo/katas', storer.path
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid kata_id on kata_exists? is false
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B7',
  'kata_exists? with invalid kata_id raises' do
    invalid_kata_ids.each do |invalid_id|
      refute storer.kata_exists?(invalid_id), invalid_id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid kata_id on any other method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '78F',
  'avatar_exists? with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.avatar_exists?(invalid_id, 'lion')
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '933',
  'create_kata() with invalid manifest[id] raises' do
    manifest = create_manifest
    assert_invalid_kata_id_raises do |invalid_id|
      manifest['id'] = invalid_id
      storer.create_kata(manifest)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '934',
  'create_kata() with missing manifest[id] raises' do
    manifest = create_manifest
    manifest.delete('id')
    error = assert_raises(ArgumentError) {
      storer.create_kata(manifest)
    }
    assert_invalid_kata_id(error)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'ABC',
  'create_kata() with duplicate kata_id raises' do
    manifest = create_manifest
    storer.create_kata(manifest)
    error = assert_raises(ArgumentError) {
      storer.create_kata(manifest)
    }
    assert_invalid_kata_id(error)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AC2',
  'kata_manifest() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.kata_manifest(invalid_id)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '965',
  'started_avatars() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.started_avatars(invalid_id)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5DF',
  'start_avatar() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.start_avatar(invalid_id, [lion])
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D9F',
  'avatar_increments() with invalud kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_increments(invalid_id, lion)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '160',
  'avatar_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_visible_files(invalid_id, lion)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D46',
  'avatar_ran_tests() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      args = [
        invalid_id,
        lion,
        starting_files,
        time_now,
        output,
        red
      ]
      storer.avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '917',
  'tag_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.tag_visible_files(invalid_id, lion, tag=3)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '918',
  'tags_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.tags_visible_files(invalid_id, lion, was_tag=2, now_tag=3)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '919',
  'tag_fork() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.tag_fork(invalid_id, lion, tag=2)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid avatar-name on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8BA',
  'avatar_exists?() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.avatar_exists?(kata_id, invalid_avatar_name)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B5F',
  'avatar_increments() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.avatar_increments(kata_id, invalid_avatar_name)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '679',
  'avatar_visible_files() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.avatar_visible_files(kata_id, invalid_avatar_name)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '941',
  'avatar_ran_tests() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      args = [
        kata_id,
        invalid_avatar_name,
        starting_files,
        time_now,
        output,
        red
      ]
      storer.avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '394',
  'avatar_ran_test() with non-existent avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      args = [
        kata_id,
        lion,
        starting_files,
        time_now,
        output,
        red
      ]
      storer.avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  #TODO other methods...

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '395',
  'tag_fork() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.tag_fork(kata_id, invalid_avatar_name, tag=0)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid tag on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '381',
  'tag_visible_files() with invalid tag raises' do
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      storer.tag_visible_files(valid_id, valid_name, bad_tag)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '382',
  'tags_visible_files() with invalid tag raises' do
    assert_bad_tag_pair_raises { |valid_id, valid_name, was_tag, now_tag|
      storer.tags_visible_files(valid_id, valid_name, was_tag, now_tag)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '383',
  'tag_fork() with invalid tag raises' do
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      storer.tag_fork(valid_id, valid_name, bad_tag)
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
  # start_avatar
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6B',
  'before starting an avatar none exist' do
    create_kata
    assert_equal([], started_avatars)
    assert_equal({}, kata_increments)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F6E',
  'rogue sub-dirs in kata-dir are not reported as avatars' do
    create_kata
    rogue = 'flintstone'
    disk[kata_path + '/' + rogue].make
    assert_equal [rogue], disk[kata_path].each_dir.collect { |name| name }
    assert_equal [], started_avatars
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBF',
  'avatar_start(not-an-avatar-name) is nil' do
    create_kata
    assert_nil start_avatar(['pencil'])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E0C', %w(
    after avatar_starts;
    avatar has no traffic-lights,
    avatar's visible_files are from the kata,
    avatar's increments already have tag zero
  ) do
    create_kata
    assert_equal lion, start_avatar([lion])
    assert_equal [lion], started_avatars
    assert_hash_equal starting_files, avatar_visible_files(lion)
    assert_hash_equal starting_files, tag_visible_files(lion, tag=0)
    tag0 =
    {
      'event'  => 'created',
      'time'   => creation_time,
      'number' => 0
    }
    assert_equal [tag0], avatar_increments(lion)
    assert_equal( { lion => [tag0] }, kata_increments)

    assert_equal tiger, start_avatar([tiger])
    assert_equal [lion,tiger].sort, started_avatars.sort
    assert_equal [tag0], avatar_increments(tiger)
    assert_equal( { lion => [tag0], tiger => [tag0] }, kata_increments)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    create_kata
    all_avatars_names.each { |name| disk[avatar_path(name)].make }
    assert_equal all_avatars_names.sort, started_avatars.sort
    assert_nil start_avatar(all_avatars_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF', %w(
    after ran_tests() there is one more tag, one more traffic-light;
    visible_files are retrievable by implicit current-tag,
    visible_files are retrievable by explicit tag,
    visible_files do not contain output
  ) do
    create_kata
    start_avatar([lion])
    was_tag = 0

    storer.avatar_ran_tests(*make_args(edited_files))
    now_tag = 1

    # traffic-lights
    expected = [
      { 'event'  => 'created',
        'time'   => creation_time,
        'number' => was_tag
      },
      { 'colour' => red,
        'time'   => time_now,
        'number' => now_tag
      }
    ]
    assert_equal expected, avatar_increments(lion)
    assert_equal({ lion => expected }, kata_increments)
    # current tag
    visible_files = avatar_visible_files(lion)
    assert_equal output, visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
    # was_tag
    was_tag_visible_files = tag_visible_files(lion, was_tag)
    refute was_tag_visible_files.keys.include? 'output'
    starting_files.each do |filename,content|
      assert_equal content, was_tag_visible_files[filename], filename
    end
    # now_tag
    now_tag_visible_files = tag_visible_files(lion, now_tag)
    assert_equal output, now_tag_visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, now_tag_visible_files[filename], filename
    end
    # both tags at once
    hash = tags_visible_files(lion, was_tag, now_tag)
    assert_hash_equal was_tag_visible_files, hash['was_tag']
    assert_hash_equal now_tag_visible_files, hash['now_tag']
  end

  private

  include AllAvatarsNames

  def lion
    'lion'
  end

  def tiger
    'tiger'
  end

  def edited_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c'       => '#include "hiker.h"',
      'hiker.h'       => '#ifndef HIKER_INCLUDED',
      'hiker.tests.c' => '#include <assert.h>'
    }
  end

  def make_args(files)
    [ kata_id, lion, files, time_now, output, red ]
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
    path_join(kata_path, name)
  end

  def kata_path
    path_join(storer.path, outer(kata_id), inner(kata_id))
  end

  def path_join(*args)
    File.join(*args)
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
    invalid_kata_ids.each do |invalid_id|
      error = assert_raises(ArgumentError) { yield invalid_id }
      assert_invalid_kata_id(error)
    end
  end

  def assert_bad_kata_id_raises
    valid_but_no_kata = 'F6316A5C7C'
    (invalid_kata_ids + [ valid_but_no_kata ]).each do |bad_id|
      error = assert_raises(ArgumentError) { yield bad_id }
      assert_invalid_kata_id(error)
    end
  end

  def assert_invalid_kata_id(error)
    assert invalid?(error, 'kata_id'), error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_avatar_names
    [ nil, [], '', 'chub' ]
  end

  def assert_bad_avatar_raises
    create_kata
    bad_avatar_names.each do |bad_name|
      error = assert_raises(ArgumentError) {
        yield kata_id, bad_name
      }
      assert invalid?(error, 'avatar_name'), error.message
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_tags
    [ nil, [], 'sunglasses', 999, -1 ]
  end

  def assert_bad_tag_raises
    create_kata
    storer.start_avatar(kata_id, [lion])
    bad_tags.each do |bad_tag|
      error = assert_raises(ArgumentError) {
        yield kata_id, lion, bad_tag
      }
      assert invalid?(error, 'tag'), error.message
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bad_tag_pairs
    [
      [nil,nil],
      [nil,[]],
      [nil,'sunglasses'],
      [nil,999],
      [0,nil],
      [0,[]],
      [0,'pen'],
      [0,999]
    ]
  end

  def assert_bad_tag_pair_raises
    create_kata
    storer.start_avatar(kata_id, [lion])
    bad_tag_pairs.each do |was_tag, now_tag|
      error = assert_raises(ArgumentError) {
        yield kata_id, lion, was_tag, now_tag
      }
      assert invalid?(error, 'tag'), error.message
    end
  end

  def invalid?(error, name)
    error.message.end_with?("invalid #{name}")
  end

end
