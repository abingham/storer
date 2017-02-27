require_relative 'test_base'
require 'json'

class StorerServiceTest < TestBase

  def self.hex_prefix; '6AA1B'; end

  test 'D43',
  'path is set to /tmp/katas from docker-compose.yml' do
    assert_equal '/tmp/katas', path
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '966',
  'bad kata-id on any method raises' do
    error = assert_raises { kata_manifest(kata_id) }
    assert error.message.end_with? 'invalid kata_id', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5F9',
  'after create_kata() then',
  'kata_exists?() is true',
  "and the kata's manifest can be retrieved",
  "and the kata's id can be completed",
  'and no avatars have yet started' do
    manifest = make_manifest

    refute kata_exists? kata_id
    create_kata(manifest)
    assert kata_exists? kata_id
    assert_equal manifest, kata_manifest(kata_id)

    no_match = kata_id.reverse[0..5]
    assert_equal no_match, completed(no_match)

    too_short = kata_id[0..4]
    assert_equal too_short, completed(too_short)

    six = kata_id[0..5]
    assert_equal 6, six.size
    assert_equal kata_id, completed(six)

    outer = kata_id[0..1]
    assert_equal [kata_id[2..-1]], completions(outer)

    assert_equal [], started_avatars(kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C18',
  'multiple katas with common first 2 digits can be completed' do
    id1 = kata_id[0..-2] + '4'
    create_kata(make_manifest(id1))
    assert_equal [id1[2..-1]], completions(kata_id[0..1])

    id2 = kata_id[0..-2] + '9'
    create_kata(make_manifest(id2))
    assert_equal [id1[2..-1],id2[2..-1]].sort, completions(kata_id[0..1]).sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '990',
  'after kata_start_avatar() succeeds',
  'then another avatar has started',
  'and has no traffic-lights yet' do
    create_kata(make_manifest)

    refute avatar_exists? kata_id, 'lion'
    assert_equal lion, start_avatar(kata_id, [lion])
    assert avatar_exists? kata_id, 'lion'

    tag0 = { 'event' => 'created', 'time' => creation_time, 'number' => 0 }
    assert_equal [tag0], avatar_increments(kata_id, lion)
    assert_equal starting_files, avatar_visible_files(kata_id, lion)
    assert_equal [lion], started_avatars(kata_id)

    assert_equal salmon, start_avatar(kata_id, [salmon])
    assert_equal [tag0], avatar_increments(kata_id, salmon)
    assert_equal starting_files, avatar_visible_files(kata_id, salmon)
    assert_equal [lion,salmon].sort, started_avatars(kata_id).sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A21',
  'after avatar_ran_tests()',
  'then there is one more traffic-light',
  'and visible_files can be retrieved for any tag' do
    create_kata(make_manifest)
    assert_equal lion, start_avatar(kata_id, [lion])

    tag1_files = starting_files
    tag1_files.delete('hiker.h')
    now = [2016, 12, 5, 21, 01, 34]
    output = 'missing include'
    colour = 'amber'
    avatar_ran_tests(kata_id, lion, tag1_files, now, output, colour)
    expected = []
    expected << tag0
    expected << { 'colour' => colour, 'time' => now, 'number' => tag=1 }
    assert_equal expected, avatar_increments(kata_id, lion)
    tag1_files['output'] = output
    assert_equal tag1_files, tag_visible_files(kata_id, lion, tag=1)

    tag2_files = tag1_files.clone
    tag2_files.delete('output')
    tag2_files['readme.txt'] = 'Your task is to print...'
    now = [2016, 12, 6, 9, 31, 56]
    output = 'All tests passed'
    colour = 'green'
    avatar_ran_tests(kata_id, lion, tag2_files, now, output, colour)
    expected << { 'colour' => colour, 'time' => now, 'number' => tag=2 }
    assert_equal expected, avatar_increments(kata_id, lion)
    tag2_files['output'] = output
    assert_equal tag1_files, tag_visible_files(kata_id, lion, tag=1)
    assert_equal tag2_files, tag_visible_files(kata_id, lion, tag=2)
    hash = tags_visible_files(kata_id, lion, was_tag=1, now_tag=2)
    assert_equal tag1_files, hash['was_tag']
    assert_equal tag2_files, hash['now_tag']
  end

  private

  def make_manifest(id = kata_id)
    {
      'image_name' => 'cyberdojofoundation/gcc_assert',
      'visible_files' => starting_files,
      'created' => creation_time,
      'id' => id
    }
  end

  def kata_id
    # reversed so I don't get common outer(id)s
    test_id.reverse + ('0' * (10-test_id.length))
  end

  def lion; 'lion'; end
  def salmon; 'salmon'; end

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
