require_relative 'test_base'
require 'json'

class StorerServiceTest < TestBase

  def self.hex_prefix; '6AA1B'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '966',
  'bad kata-id on any method raises' do
    error = assert_raises { kata_manifest(test_id) }
    assert_equal 'StorerService:kata_manifest:invalid kata_id', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '6E7',
  'retrieved manifest contains kata-id' do
    manifest = make_manifest
    kata_id = kata_create(manifest)
    manifest['id'] = kata_id
    assert_equal manifest, kata_manifest(kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5F9',
  'after kata_create() then',
  'kata_exists?() is true',
  "and the kata's manifest can be retrieved",
  "and the kata's id can be completed",
  'and no avatars have yet started' do
    manifest = make_manifest
    kata_id = kata_create(manifest)

    assert kata_exists?(kata_id)
    assert_equal [], avatars_started(kata_id)
    assert_equal({}, kata_increments(kata_id))

    too_short = kata_id[0..4]
    assert_equal '', completed(too_short)

    assert_equal kata_id, completed(kata_id[0..5])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '507',
  'completions' do
    manifest = make_manifest
    kata_id = kata_create(manifest)
    outer = kata_id[0..1]
    inner = kata_id[2..-1]
    assert completions(outer).include?(inner)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '990',
  'after avatar_start() succeeds',
  'then another avatar has started',
  'and has no traffic-lights yet' do
    kata_id = kata_create(make_manifest)

    refute avatar_exists?(kata_id, lion)
    assert_equal lion, avatar_start(kata_id, [lion])
    assert avatar_exists?(kata_id, lion)

    assert_equal [tag0], avatar_increments(kata_id, lion)
    assert_equal({ lion => [tag0] }, kata_increments(kata_id))
    assert_equal starting_files, avatar_visible_files(kata_id, lion)
    assert_equal [lion], avatars_started(kata_id)

    assert_equal salmon, avatar_start(kata_id, [salmon])
    assert_equal [tag0], avatar_increments(kata_id, salmon)
    assert_equal({ lion => [tag0], salmon => [tag0] }, kata_increments(kata_id))
    assert_equal starting_files, avatar_visible_files(kata_id, salmon)
    assert_equal [lion,salmon].sort, avatars_started(kata_id).sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A21',
  'after avatar_ran_tests()',
  'then there is one more traffic-light',
  'and visible_files can be retrieved for any tag' do
    kata_id = kata_create(make_manifest)
    assert_equal lion, avatar_start(kata_id, [lion])

    tag1_files = starting_files
    tag1_files.delete('hiker.h')
    now = [2016, 12, 5, 21, 01, 34]
    stdout = 'missing include'
    stderr = 'assert failed'
    colour = 'amber'
    avatar_ran_tests(kata_id, lion, tag1_files, now, stdout, stderr, colour)
    expected = []
    expected << tag0
    expected << { 'colour' => colour, 'time' => now, 'number' => tag=1 }
    assert_equal expected, avatar_increments(kata_id, lion)
    assert_equal({ lion => expected }, kata_increments(kata_id))
    tag1_files['output'] = stdout + stderr
    assert_equal tag1_files, tag_visible_files(kata_id, lion, tag=1)

    tag2_files = tag1_files.clone
    tag2_files.delete('output')
    tag2_files['readme.txt'] = 'Your task is to print...'
    now = [2016, 12, 6, 9, 31, 56]
    stdout = 'All tests passed'
    stderr = ''
    colour = 'green'
    avatar_ran_tests(kata_id, lion, tag2_files, now, stdout, stderr, colour)
    expected << { 'colour' => colour, 'time' => now, 'number' => tag=2 }
    assert_equal expected, avatar_increments(kata_id, lion)
    assert_equal( { lion => expected }, kata_increments(kata_id))
    tag2_files['output'] = stdout + stderr
    assert_equal tag1_files, tag_visible_files(kata_id, lion, tag=1)
    assert_equal tag2_files, tag_visible_files(kata_id, lion, tag=2)
    hash = tags_visible_files(kata_id, lion, was_tag=1, now_tag=2)
    assert_equal tag1_files, hash['was_tag']
    assert_equal tag2_files, hash['now_tag']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '722',
  'avatar_ran_tests() with very large file does not raise' do
    # This test fails if docker-compose.yml uses
    # [read_only:true] without also using
    # [tmpfs: /tmp]
    kata_id = kata_create(make_manifest)
    assert_equal lion, avatar_start(kata_id, [lion])

    files = starting_files
    files['very_large'] = 'X'*1024*500
    now = [2016, 12, 5, 21, 01, 34]
    stdout = 'missing include'
    stderr = 'assertion failed'
    colour = 'amber'
    avatar_ran_tests(kata_id, lion, files, now, stdout, stderr, colour)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5EE',
  'you can fork from any tag' do
    id = '420B05BA0A'
    tag = 20
    now = [2018,3,16,9,57,19]
    forked_id = tag_fork(id, 'dolphin', tag, now)
    refute_equal forked_id, id
  end

  private

  def make_manifest
    {
      'image_name' => 'cyberdojofoundation/gcc_assert',
      'visible_files' => starting_files,
      'created' => creation_time,
      'max_seconds' => 10,
      'runner_choice' => 'stateless',
      'highlight_filenames' => [],
      'lowlight_filenames' => [ 'cyber-dojo.sh', 'makefile', 'Makefile', 'unity.license.txt' ],
      'filename_extension' => '',
      'progress_regexs' => [],
      'tab_size' => 4
    }
  end

  def lion
    'lion'
  end

  def salmon
    'salmon'
  end

  def starting_files
    {
      'cyber-dojo.sh' => 'gcc',
      'hiker.c'       => '#include "hiker.h"',
      'hiker.h'       => '#include <stdio.h>'
    }
  end

  def tag0
    {
      'event'  => 'created',
      'time'   => creation_time,
      'number' => tag=0
    }
  end

  def creation_time
    [ 2016, 12, 15, 17, 26, 34 ]
  end

end
