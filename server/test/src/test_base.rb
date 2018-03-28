require_relative '../../src/rack_dispatcher'
require_relative '../../src/all_avatars_names'
require_relative '../../src/externals'
require_relative 'rack_request_stub'
require_relative 'hex_mini_test'
require_relative 'starter_service'
require 'json'

class TestBase < HexMiniTest

  def kata_manifest(kata_id)
    storer.kata_manifest(kata_id)
  end

  def kata_increments(kata_id)
    storer.kata_increments(kata_id)
  end

  def kata_exists?(kata_id)
    storer.kata_exists?(kata_id)
  end

  def katas_completed(partial_id)
    storer.katas_completed(partial_id)
  end

  def katas_completions(partial_id)
    storer.katas_completions(partial_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_start(kata_id, avatar_names)
    storer.avatar_start(kata_id, avatar_names)
  end

  def avatars_started(kata_id)
    storer.avatars_started(kata_id)
  end

  def avatar_exists?(kata_id, name)
    storer.avatar_exists?(kata_id, name)
  end

  def avatar_ran_tests(kata_id, name, files, now, stdout, stderr, colour)
    args = [
      kata_id,
      name,
      files,
      now,
      stdout,
      stderr,
      colour
    ]
    storer.avatar_ran_tests(*args)
  end

  def avatar_increments(kata_id, name)
    storer.avatar_increments(kata_id, name)
  end

  def avatar_visible_files(kata_id, name)
    storer.avatar_visible_files(kata_id, name)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def tag_fork(kata_id, name, tag, now)
    storer.tag_fork(kata_id, name, tag, now)
  end

  def tag_visible_files(kata_id, name, tag)
    storer.tag_visible_files(kata_id, name, tag)
  end

  def tags_visible_files(kata_id, name, was_tag, now_tag)
    storer.tags_visible_files(kata_id, name, was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def make_kata(visible_files = nil)
    manifest = create_manifest(visible_files)
    storer.kata_create(manifest)
  end

  def create_manifest(visible_files = nil)
    manifest = starter.language_manifest('C (gcc), assert', 'Fizz_Buzz')
    unless visible_files.nil?
      manifest['visible_files'] = visible_files
    end
    manifest['created'] = creation_time
    manifest
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  include AllAvatarsNames
  include Externals

  def starter
    StarterService.new
  end

  def starting_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c'       => '#include "hiker.h"',
      'hiker.h'       => '#include <stdio.h>'
    }
  end

  def creation_time
    [2016, 12, 2, 6, 13, 23]
  end

  def outer(id)
    id[0..1]
  end

  def inner(id)
    id[2..-1]
  end

  def cyber_dojo_katas_root
    ENV['CYBER_DOJO_KATAS_ROOT']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

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

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def bare_manifest
    {
      display_name:'C (gcc), assert',
      visible_files:{ 'cyber-dojo.sh':'make' },
      image_name:'cyberdojofoundation/gcc_assert',
      runner_choice:'stateless'
    }.dup
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_hash_equal(expected, actual)
    diagnostic = ''
    diagnostic += "expected[#{expected.keys.sort}]\n"
    diagnostic += "actual[#{actual.keys.sort}]\n"
    assert_equal expected.size, actual.size, diagnostic
    expected.each do |symbol,value|
      assert_equal value, actual[symbol.to_s], symbol.to_s
    end
  end

  def assert_rack_call(path_info, args, expected)
    assert_rack_call_raw(path_info, args.to_json, expected)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call_raw(path_info, args, expected)
    tuple = rack_call(path_info, args)
    assert_equal 200, tuple[0]
    assert_equal({ 'Content-Type' => 'application/json' }, tuple[1])
    assert_equal [ expected.to_json ], tuple[2], args
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def rack_call(path_info, args)
    refute path_info.end_with?('?'), 'http drops trailing ?'
    rack = RackDispatcher.new(RackRequestStub)
    env = { path_info:path_info, body:args }
    rack.call(env)
  end

end
