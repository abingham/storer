require 'json'
require_relative './client_test_base'

class KataExistsTest < ClientTestBase

  def self.hex_prefix; '6AA1B'; end

  test 'E98',
  'kata_exists?() for a kata_id that is not a 10-digit hex-string is false' do
    refute kata_exists?('123')
  end

  test '33F',
  'kata_exists?() for a kata_id that is 10-digit hex-string but not a kata is false' do
    refute kata_exists?(kata_id)
  end

  test '5F9',
  'after create_kata() then',
  'kata_exists?() is true',
  'and manifest can be retrieved',
  'and id can be completed',
  'and no avatars have started' do
    manifest = {}
    manifest['image_name'] = 'cyberdojofoundation/gcc_assert'
    manifest['visible_files'] = starting_files
    manifest['id'] = kata_id

    create_kata(manifest)
    assert kata_exists?(kata_id)

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

    assert_equal [], kata_started_avatars(kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '990',
  'after kata_start_avatar() succeeds',
  'then another avatar has started',
  'and has no traffic-lights yet' do
    manifest = {}
    manifest['image_name'] = 'cyberdojofoundation/gcc_assert'
    manifest['visible_files'] = starting_files
    manifest['id'] = kata_id

    create_kata(manifest)

    assert_equal lion, kata_start_avatar(kata_id, [lion])
    assert_equal [lion], kata_started_avatars(kata_id)
    assert_equal [], avatar_increments(kata_id, lion)

    assert_equal salmon, kata_start_avatar(kata_id, [salmon])
    assert_equal [lion,salmon].sort, kata_started_avatars(kata_id).sort
    assert_equal [], avatar_increments(kata_id, salmon)
  end


  private

  def kata_id
    # reversed so I don't get common outer(id)s
    test_id.reverse + '0' * (10-test_id.length);
  end

  def lion; 'lion'; end
  def salmon; 'salmon'; end

  def starting_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#include <stdio.h>'
    }
  end

end
