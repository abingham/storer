require_relative '../../src/rack_dispatcher'
require_relative 'rack_request_stub'
require_relative 'test_base'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'D6479'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # malformed kata-id on any method raises
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6B7',
  'kata_exists? raises if kata-id is malformed' do
    malformed_kata_ids.each do |malformed_kata_id|
      args = {
        kata_id:malformed_kata_id
      }
      expected = {
        exception:'kata_id:malformed'
      }
      assert_rack_call('kata_exists', args, expected)
    end
  end

=begin

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

  test 'C1C',
  'katas_completed with malformed kata_id raises' do
    invalid_partial_ids = [
      nil,          # not an object
      [],           # not a string
      '=4',         # not Base58 chars
    ].each do |invalid_partial_id|
      error = assert_raises(ArgumentError) {
        storer.katas_completed(invalid_partial_id)
      }
      assert error.message.end_with?('invalid kata_id'), error.message
    end
  end

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

  test 'CBF',
  'avatar_start(not-an-avatar-name) is nil' do
    id = make_kata
    assert_nil avatar_start(id, ['pencil'])
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

=end

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

  def assert_rack_call(path_info, args, expected)
    assert_rack_call_raw(path_info, args.to_json, expected)
  end

  def assert_rack_call_raw(path_info, args, expected)
    tuple = rack_call(path_info, args)
    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_equal [ expected.to_json ], tuple[2]
  end

  def rack_call(path_info, args)
    refute path_info.end_with?('?'), 'http drops trailing ?'
    rack = RackDispatcher.new(RackRequestStub)
    env = { path_info:path_info, body:args }
    rack.call(env)
  end

end
