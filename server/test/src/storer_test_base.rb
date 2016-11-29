require 'json'
# coverage must come first
require_relative '../coverage'
require_relative '../hex_mini_test'
require_relative './../../src/host_disk_storer'
require_relative './../../src/externals'

class StorerTestBase < HexMiniTest

  def kata_setup
  end

  def kata_teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  include Externals
  def storer; @storer ||= HostDiskStorer.new(self); end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_exec(cmd)
    stdout,stderr,status = exec(cmd)
    assert_equal success, status, [stdout,stderr]
    [stdout,stderr]
  end

  def exec(cmd, logging = true)
    shell.exec(cmd, logging)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def success; runner.success; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_id; test_id + '0' * (10-test_id.length); end
  def avatar_name; 'salmon'; end

end
