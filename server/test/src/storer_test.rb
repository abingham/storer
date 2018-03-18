require_relative 'test_base'

class StorerTest < TestBase

  def self.hex_prefix
    'E4FDA'
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
  # kata_exists? never raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B7',
  'kata_exists? is false for invalid kata_id' do
    invalid_kata_ids.each do |invalid_id|
      refute kata_exists?(invalid_id), invalid_id
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_exists? never raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '78E',
  'avatar_exists? is false for invalid kata_id' do
    invalid_kata_ids.each do |invalid_id|
      refute avatar_exists?(invalid_id, 'dolphin'), invalid_id
    end
  end

  test '78F',
  'avatar_exists? is false for invalid avatar_name' do
    manifest = create_manifest
    kata_id = manifest['id']
    invalid_avatar_names.each do |invalid_name|
      refute avatar_exists?(kata_id, invalid_name), invalid_name
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid kata_id on any other method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AC2',
  'kata_manifest() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      kata_manifest(invalid_id)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '965',
  'avatars_started() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      avatars_started(invalid_id)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5DF',
  'avatar_start() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      avatar_start(invalid_id, [lion])
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D9F',
  'avatar_increments() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      avatar_increments(invalid_id, lion)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '160',
  'avatar_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      avatar_visible_files(invalid_id, lion)
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
        stdout,
        stderr,
        red
      ]
      avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '916',
  'tag_fork() with invalid kata_id raises' do
    now = [2018,3,16,9,57,19]
    assert_bad_kata_id_raises { |invalid_id|
      tag_fork(invalid_id, lion, tag=3, now)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '917',
  'tag_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      tag_visible_files(invalid_id, lion, tag=3)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '918',
  'tags_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      tags_visible_files(invalid_id, lion, was_tag=2, now_tag=3)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid avatar-name raises on any other method
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B5F',
  'avatar_increments() with invalid avatar_name raises' do
    assert_invalid_avatar_raises { |kata_id, invalid_avatar_name|
      avatar_increments(kata_id, invalid_avatar_name)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '679',
  'avatar_visible_files() with invalid avatar_name raises' do
    assert_invalid_avatar_raises { |kata_id, invalid_avatar_name|
      avatar_visible_files(kata_id, invalid_avatar_name)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '941',
  'avatar_ran_tests() with invalid avatar_name raises' do
    assert_invalid_avatar_raises { |kata_id, invalid_avatar_name|
      args = [
        kata_id,
        invalid_avatar_name,
        starting_files,
        time_now,
        stdout,
        stderr,
        red
      ]
      avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '394',
  'avatar_ran_test() with non-existent avatar_name raises' do
    assert_invalid_avatar_raises { |kata_id, _invalid_avatar_name|
      args = [
        kata_id,
        lion, # valid but does not exist
        starting_files,
        time_now,
        stdout,
        stderr,
        red
      ]
      avatar_ran_tests(*args)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '072',
  %w( tag_fork with invalid avatar_name raises ) do
    kata_id = make_kata
    now = [2018,3,16,9,57,19]
    error = assert_raises(ArgumentError) {
      tag_fork(kata_id, 'xxx', 20, now)
    }
    assert_equal 'invalid avatar_name', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '073',
  %w( tag_visible_files with invalid avatar_name raises ) do
    kata_id = make_kata
    error = assert_raises(ArgumentError) {
      tag_visible_files(kata_id, 'xxx', 20)
    }
    assert_equal 'invalid avatar_name', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '074',
  %w( tags_visible_files with invalid avatar_name raises ) do
    kata_id = make_kata
    error = assert_raises(ArgumentError) {
      tags_visible_files(kata_id, 'xxx', 20, 21)
    }
    assert_equal 'invalid avatar_name', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid tag on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '380',
  'tag_fork() with invalid tag raises' do
    now = [2018,3,16,9,57,19]
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      tag_fork(valid_id, valid_name, bad_tag, now)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '381',
  'tag_visible_files() with invalid tag raises' do
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      tag_visible_files(valid_id, valid_name, bad_tag)
    }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '382',
  'tags_visible_files() with invalid tag raises' do
    assert_bad_tag_pair_raises { |valid_id, valid_name, was_tag, now_tag|
      tags_visible_files(valid_id, valid_name, was_tag, now_tag)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_create
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B99',
  'after kata_create(manifest) manifest has id/created properties' do
    expected = %w(
      created
      display_name
      exercise
      filename_extension
      image_name
      runner_choice
      visible_files
    )
    manifest = create_manifest
    assert_equal expected.sort, manifest.keys.sort

    id = storer.kata_create(manifest)
    manifest = kata_manifest(id)
    assert_equal (expected << 'id').sort, manifest.keys.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_start, avatars_started
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6B',
  'before starting an avatar none exist' do
    id = make_kata
    assert_equal([], avatars_started(id))
    assert_equal({}, kata_increments(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F6E',
  'rogue sub-dirs in kata-dir are not reported as avatars' do
    id = make_kata
    rogue = 'flintstone'
    disk[kata_path(id) + '/' + rogue].make
    assert_equal [rogue], disk[kata_path(id)].each_dir.collect { |name| name }
    assert_equal [], avatars_started(id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBF',
  'avatar_start(not-an-avatar-name) is nil' do
    id = make_kata
    assert_nil avatar_start(id, ['pencil'])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E0C', %w(
    after avatar_starts;
    avatar has no traffic-lights,
    avatar's visible_files are from the kata,
    avatar's increments already have tag zero
  ) do
    id = make_kata
    assert_equal lion, avatar_start(id, [lion])
    assert_equal [lion], avatars_started(id)
    expected_filenames = %w(
      cyber-dojo.sh
      hiker.h
      hiker.c
      hiker.tests.c
      instructions
      makefile
      output
    ).sort
    assert_equal expected_filenames, avatar_visible_files(id, lion).keys.sort
    assert_equal expected_filenames, tag_visible_files(id, lion, tag=0).keys.sort
    tag0 =
    {
      'event'  => 'created',
      'time'   => creation_time,
      'number' => 0
    }
    assert_equal [tag0], avatar_increments(id, lion)
    assert_equal( { lion => [tag0] }, kata_increments(id))

    assert_equal tiger, avatar_start(id, [tiger])
    assert_equal [lion,tiger].sort, avatars_started(id).sort
    assert_equal [tag0], avatar_increments(id, tiger)
    assert_equal( { lion => [tag0], tiger => [tag0] }, kata_increments(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    id = make_kata
    all_avatars_names.size.times do
      avatar_start(id, all_avatars_names)
    end
    assert_equal all_avatars_names.sort, avatars_started(id).sort
    assert_nil avatar_start(id, all_avatars_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF', %w(
    after ran_tests() there is one more tag, one more traffic-light;
    visible_files are retrievable by implicit current-tag,
    visible_files are retrievable by explicit tag
  ) do
    kata_id = make_kata(starting_files)
    avatar_start(kata_id, [lion])
    was_tag = 0

    avatar_ran_tests(*make_args(kata_id, edited_files))
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
    assert_equal expected, avatar_increments(kata_id, lion)
    assert_equal({ lion => expected }, kata_increments(kata_id))
    # current tag
    visible_files = avatar_visible_files(kata_id, lion)
    assert_equal stdout+stderr, visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
    # was_tag
    was_tag_visible_files = tag_visible_files(kata_id, lion, was_tag)
    refute was_tag_visible_files.keys.include?('output')
    starting_files.each do |filename,content|
      assert_equal content, was_tag_visible_files[filename], filename
    end
    # now_tag
    now_tag_visible_files = tag_visible_files(kata_id, lion, now_tag)
    assert_equal stdout+stderr, now_tag_visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, now_tag_visible_files[filename], filename
    end
    # both tags at once
    hash = tags_visible_files(kata_id, lion, was_tag, now_tag)
    assert_hash_equal was_tag_visible_files, hash['was_tag']
    assert_hash_equal now_tag_visible_files, hash['now_tag']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag_fork
  # test-data: 420B05BA0A, dolphin, 20 rags
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '818',
  %w( tag_fork with valid arguments ) do
    id = '420B05BA0A'
    tag = 20
    now = [2018,3,16,9,57,19]
    forked_id = tag_fork(id, 'dolphin', tag, now)
    refute_equal forked_id, id

    manifest = kata_manifest(id)
    forked_manifest = kata_manifest(forked_id)
    assert_equal manifest.keys.sort, forked_manifest.keys.sort
    manifest.keys.each do |key|
      case key
        when 'id'
          assert_equal id, manifest['id']
          assert_equal forked_id, forked_manifest['id']
        when 'created'
          refute_equal manifest['created'], forked_manifest['created']
          assert_equal now, forked_manifest['created']
        when 'visible_files'
          refute_equal manifest['visible_files'], forked_manifest['visible_files']
          assert_equal tag_visible_files(id, 'dolphin', tag), forked_manifest['visible_files']
        else
          assert_equal manifest[key], forked_manifest[key]
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag_visible_files
  # test-data: 420B05BA0A, dolphin, 20 rags
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '170',
  %w( tag_visible_files with valid +ve tag ) do
    visible_files = tag_visible_files('420B05BA0A', 'dolphin', 20)
    expected = %w(
      Calcolatrice.java
      HikerTest.java
      cyber-dojo.sh
      instructions
      output
    )
    assert_equal expected.sort, visible_files.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '171',
  %w( tag_visible_files with -1 tag is last tag ) do
    visible_files = tag_visible_files('420B05BA0A', 'dolphin', -1)
    expected = %w(
      Calcolatrice.java
      HikerTest.java
      cyber-dojo.sh
      instructions
      output
    )
    assert_equal expected.sort, visible_files.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '172',
  %w( tag_visible_files raises when tag is invalid ) do
    error = assert_raises(ArgumentError) {
      tag_visible_files('420B05BA0A', 'dolphin', 21)
    }
    assert_equal 'invalid tag', error.message
  end

  private # = = = = = = = = = = = = = = = = = = = = = = =

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

  def make_args(id, files)
    [ id, lion, files, time_now, stdout, stderr, red ]
  end

  def time_now
    [2016, 12, 2, 6, 14, 57]
  end

  def stdout
    ''
  end

  def stderr
    'Assertion failed: answer() == 42'
  end

  def red
    'red'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_path(kata_id)
    path_join(storer.path, outer(kata_id), inner(kata_id))
  end

  def path_join(*args)
    File.join(*args)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bad_kata_id_raises
    valid_but_no_kata = 'F6316A5C7C'
    (invalid_kata_ids + [ valid_but_no_kata ]).each do |bad_id|
      error = assert_raises(ArgumentError) { yield bad_id }
      assert_invalid_kata_id(error)
    end
  end

  def assert_invalid_kata_id_raises
    invalid_kata_ids.each do |invalid_id|
      error = assert_raises(ArgumentError) { yield invalid_id }
      assert_invalid_kata_id(error)
    end
  end

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

  def assert_invalid_kata_id(error)
    assert invalid?(error, 'kata_id'), error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_invalid_avatar_raises
    kata_id = make_kata
    invalid_avatar_names.each do |invalid_name|
      error = assert_raises(ArgumentError) {
        yield kata_id, invalid_name
      }
      assert invalid?(error, 'avatar_name'), error.message
    end
  end

  def invalid_avatar_names
    [
      nil,     # not an object
      [],      # not a string
      '',      # not a name
      'blurb', # not a name
      'dolpin' # not a name (dolphin has an H)
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bad_tag_raises
    kata_id = make_kata
    avatar_start(kata_id, [lion])
    bad_tags.each do |bad_tag|
      error = assert_raises(ArgumentError) {
        yield kata_id, lion, bad_tag
      }
      assert invalid?(error, 'tag'), error.message
    end
  end

  def bad_tags
    [ nil, [], 'sunglasses', 999 ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_bad_tag_pair_raises
    kata_id = make_kata
    avatar_start(kata_id, [lion])
    bad_tag_pairs.each do |was_tag, now_tag|
      error = assert_raises(ArgumentError) {
        yield kata_id, lion, was_tag, now_tag
      }
      assert invalid?(error, 'tag'), error.message
    end
  end

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

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def invalid?(error, name)
    error.message.end_with?("invalid #{name}")
  end

end
