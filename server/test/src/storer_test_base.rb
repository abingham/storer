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

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  def success; runner.success; end

  def kata_id; test_id + '0' * (10-test_id.length); end

  def avatar_name; 'salmon'; end

end
