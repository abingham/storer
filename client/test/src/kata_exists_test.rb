require 'json'
require_relative './client_test_base'

class KataExistsTest < ClientTestBase

  def self.hex_prefix; '6AA1B'; end

  test 'E98',
  'kata_exists?() for a kata_id that is not a 10-digit hex-string is false' do
    kata_exists?('123')
    assert_status false
  end

  test '33F',
  'kata_exists?() for a kata_id that is 10-digit hex-string but not a kata is false' do
    kata_exists?(kata_id)
    assert_status false
  end

  test '5F9',
  'after create_kata() then',
  'kata_exists?() is true',
  'and manifest can be retrieved',
  'and id can be completed' do
    manifest = {}
    manifest['image_name'] = 'cyberdojofoundation/gcc_assert'
    manifest['visible_files'] = starting_files
    manifest['id'] = kata_id

    create_kata(manifest)
    assert_success

    kata_exists?(kata_id)
    assert_status true

    kata_manifest(kata_id)
    assert_equal manifest, JSON.parse(stdout)

    completed(kata_id[0..5])
    assert_equal kata_id, stdout
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -



  private

  def kata_id
    # reversed so I don't get common outer(id)s
    test_id.reverse + '0' * (10-test_id.length);
  end

  def starting_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#include <stdio.h>'
    }
  end

end