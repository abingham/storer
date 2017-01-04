require_relative 'bash_sheller'
require_relative 'disk_writer'
require_relative 'gitter'
require_relative 'host_disk_storer'
require_relative 'stdout_logger'

module Externals

  def storer; @storer ||= HostDiskStorer.new(self); end
  def  shell;  @shell ||=    BashSheller.new(self); end
  def   disk;   @disk ||=     DiskWriter.new(self); end
  def    git;    @git ||=         Gitter.new(self); end
  def    log;    @log ||=   StdoutLogger.new(self); end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use with NearestAncestors as follows:
#
# 1. include Externals in your top-level scope.
#
#    require_relative 'externals'
#    class MicroService < Sinatra::Base
#      ...
#      private
#      include Externals
#      ...
#    end
#
# 2. ensure all child objects have access to their parent
#    and gain access to the externals via nearest_external()
#
#    require_relative 'nearest_ancestors'
#    class DiskWriter
#      def initialize(parent)
#        @parent = parent
#      end
#      attr_reader :parent
#      ...
#      private
#      include NearestAncestors
#      def log; nearest_ancestors(:log); end
#    end
#
# 3. tests simply set the external directly.
#    Note that Externals.log uses @log ||= ...
#
#    class DiskWriterTest < MiniTest::Test
#      def test_something
#        @log = SpyLogger.new(...)
#        storer = DiskWriter.new(self)
#        storer.do_something
#        assert_equal 'expected', log.spied
#      end
#    end
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
