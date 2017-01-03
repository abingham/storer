require_relative '../hex_mini_test'
require_relative '../../src/host_disk_storer'
require_relative '../../src/externals'
require 'json'

class TestBase < HexMiniTest

  def kata_manifest
    storer.kata_manifest(kata_id)
  end

  def avatar_increments(name)
    storer.avatar_increments(kata_id, name)
  end

  def avatar_visible_files(name)
    storer.avatar_visible_files(kata_id, name)
  end

  def tag_visible_files(name, tag)
    storer.tag_visible_files(kata_id, name, tag)
  end

  def tags_visible_files(name, was_tag, now_tag)
    storer.tags_visible_files(kata_id, name, was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_id
    test_id.reverse # reversed so I don't get common outer(id)s
  end

  def create_kata(id = kata_id)
    manifest = create_manifest(id)
    storer.create_kata(manifest)
    manifest
  end

  def create_manifest(id = kata_id)
    {
      'image_name'    => 'cyberdojofoundation/gcc_assert',
      'visible_files' => starting_files,
      'created'       => creation_time,
      'id'            => id
    }
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

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  def success; runner.success; end

  def avatar_name; 'salmon'; end

end