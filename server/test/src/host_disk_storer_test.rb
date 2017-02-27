require_relative 'test_base'
require_relative 'spy_logger'
require_relative '../../src/all_avatars_names'

class HostDiskStorerTest < TestBase

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
  # invalid kata_id on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B7',
  'kata_exists? with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.kata_exists?(invalid_id)
    }
  end

  test '78F',
  'avatar_exists? with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.avatar_exists?(invalid_id, 'lion')
    }
  end

  test '933',
  'create_kata() with invalid manifest[id] raises' do
    manifest = create_manifest
    assert_invalid_kata_id_raises do |invalid_id|
      manifest['id'] = invalid_id
      storer.create_kata(manifest)
    end
  end

  test '934',
  'create_kata() with missing manifest[id] raises' do
    manifest = create_manifest
    manifest.delete('id')
    error = assert_raises(ArgumentError) {
      storer.create_kata(manifest)
    }
    assert_invalid_kata_id(error)
  end

  test 'ABC',
  'create_kata() with duplicate kata_id raises' do
    manifest = create_manifest
    storer.create_kata(manifest)
    error = assert_raises(ArgumentError) {
      storer.create_kata(manifest)
    }
    assert_invalid_kata_id(error)
  end

  test 'AC2',
  'kata_manifest() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.kata_manifest(invalid_id)
    }
  end

  test '965',
  'started_avatars() with invalid kata_id raises' do
    assert_invalid_kata_id_raises { |invalid_id|
      storer.started_avatars(invalid_id)
    }
  end

  test '5DF',
  'start_avatar() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.start_avatar(invalid_id, [lion])
    }
  end

  test 'D9F',
  'avatar_increments() with invalud kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_increments(invalid_id, lion)
    }
  end

  test '160',
  'avatar_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.avatar_visible_files(invalid_id, lion)
    }
  end

  test 'D46',
  'avatar_ran_tests() with invalid kata_id raises' do
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
  'tag_visible_files() with invalid kata_id raises' do
    assert_bad_kata_id_raises { |invalid_id|
      storer.tag_visible_files(invalid_id, lion, tag=3)
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

  test 'B5F',
  'avatar_increments() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.avatar_increments(kata_id, invalid_avatar_name)
    }
  end

  test '679',
  'avatar_visible_files() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      storer.avatar_visible_files(kata_id, invalid_avatar_name)
    }
  end

  test '941',
  'avatar_ran_tests() with invalid avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      args = []
      args << kata_id
      args << invalid_avatar_name
      args << starting_files
      args << time_now
      args << output
      args << red
      storer.avatar_ran_tests(*args)
    }
  end

  test '394',
  'avatar_ran_test() with non-existent avatar_name raises' do
    assert_bad_avatar_raises { |kata_id, invalid_avatar_name|
      args = []
      args << kata_id
      args << 'lion'
      args << starting_files
      args << time_now
      args << output
      args << red
      storer.avatar_ran_tests(*args)
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # invalid tag on any method raises
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '388',
  'tag_visible_files() with invalid tag raises' do
    assert_bad_tag_raises { |valid_id, valid_name, bad_tag|
      storer.tag_visible_files(valid_id, valid_name, bad_tag)
    }
  end

  test '9E7',
  'tags_visible_files() with invalid tag raises' do
    assert_bad_tag_pair_raises { |valid_id, valid_name, was_tag, now_tag|
      storer.tags_visible_files(valid_id, valid_name, was_tag, now_tag)
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
    assert_equal [{
      'event'  => 'created',
      'time'   => creation_time,
      'number' => 0
    }], avatar_increments(lion)
  end

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    create_kata
    all_avatars_names.each { |name| disk[avatar_path(name)].make }
    assert_equal all_avatars_names.sort, storer.started_avatars(kata_id).sort
    assert_nil storer.start_avatar(kata_id, all_avatars_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF',
  'after ran_tests() there is one more tag, one more traffic-light;',
  'visible_files are retrievable by implicit current-tag',
  'visible_files are retrievable by explicit tag',
  'visible_files do not contain output' do
    create_kata
    storer.start_avatar(kata_id, [lion])
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
    tag0 = {
      'event'  => 'created',
      'time'   => [ 2016, 11, 23, 8, 34, 28 ],
      'number' => 0
    }
    assert_hash_equal tag0, rags[0]
    tag1 = {
      'colour'  => 'red',
      'time'    => [ 2016, 11, 23, 8, 34, 33 ],
      'number'  => 1
    }
    assert_hash_equal tag1, rags[1]
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
    expected = [
      '',
      'class Hiker:',
      '',
      '    def answer(self, first, second):',
      '        return first * second',
      ''
    ].join("\n")
    assert_equal expected, files['hiker.py']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '765',
  'old git-format tag-non-zero visible-files can be retrieved' do
    kata_id = '5A0F824303'
    spider = 'spider'
    files1 = storer.tag_visible_files(kata_id, spider, tag=1)
    expected_filenames = [
      'cyber-dojo.sh',
      'instructions',
      'README',
      'hiker.feature',
      'hiker.py',
      'hiker_steps.py',
      'output'
    ]
    assert_equal expected_filenames.sort, files1.keys.sort
    expected1 = [
      '',
      'Feature: hitch-hiker playing scrabble',
      '',
      'Scenario: last earthling playing scrabble in the past',
      'Given the hitch-hiker selects some tiles',
      'When they spell 6 times 9', # <-----
      'Then the score is 42',
      ''
    ].join("\n")
    assert_equal expected1, files1['hiker.feature']

    files2 = storer.tag_visible_files(kata_id, spider, tag=2)
    assert_equal expected_filenames.sort, files2.keys.sort
    expected2 = [
      '',
      'Feature: hitch-hiker playing scrabble',
      '',
      'Scenario: last earthling playing scrabble in the past',
      'Given the hitch-hiker selects some tiles',
      'When they spell 6 times 7', # <-----
      'Then the score is 42',
      ''
    ].join("\n")
    assert_equal expected2, files2['hiker.feature']
  end

  private

  include AllAvatarsNames

  def lion
    'lion'
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
