require 'json'
require_relative '../hex_mini_test'
require_relative './../../src/host_disk_storer'
require_relative './../../src/externals'

class StorerTestBase < HexMiniTest

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  def success; runner.success; end

  def kata_id; test_id + '0' * (10-test_id.length); end

  def avatar_name; 'salmon'; end

end
