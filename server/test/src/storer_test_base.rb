require 'json'
require_relative '../hex_mini_test'
require_relative './../../src/host_disk_storer'
require_relative './../../src/externals'

class StorerTestBase < HexMiniTest

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

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  def success; runner.success; end

  def avatar_name; 'salmon'; end

end
