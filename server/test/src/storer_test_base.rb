require 'json'
require_relative '../hex_mini_test'
require_relative './../../src/host_disk_storer'
require_relative './../../src/externals'

class StorerTestBase < HexMiniTest

  def kata_exists?(kata_id)
    storer.kata_exists(kata_id)
  end

  def avatar_exists?(kata_id, avatar_name)
    storer.avatar_exists(kata_id, avatar_name)
  end

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

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  def success; runner.success; end

  def avatar_name; 'salmon'; end

end
