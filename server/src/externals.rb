require_relative 'external_disk_writer'
require_relative 'external_sheller'
require_relative 'external_gitter'
require_relative 'external_stdout_logger'

module Externals

  def shell; @shell ||= ExternalSheller.new(self); end
  def  disk;  @disk ||= ExternalDiskWriter.new(self); end
  def   git;   @git ||= ExternalGitter.new(self); end
  def   log;   @log ||= ExternalStdoutLogger.new(self); end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use with NearestExternal as follows:
#
# 1. include Externals in your top-level scope.
#
#    require_relative './externals'
#    class MicroService < Sinatra::Base
#      ...
#      private
#      include Externals
#      def storer; HostDiskStorer.new(self); end
#      ...
#    end
#
# 2. ensure all child objects have access to their parent
#    and gain access to the externals via nearest_external()
#
#    require_relative './nearest_external'
#    class HostDiskStorer
#      def initialize(parent)
#        @parent = parent
#      end
#      attr_reader :parent
#      ...
#      private
#      include NearestExternal
#      def log; nearest_external(:log); end
#    end
#
# 3. tests simply set the external directly.
#    Note that Externals.log uses @log ||= ...
#
#    class HostDiskStorerTest < MiniTest::Test
#      def test_something
#        @log = SpyLogger.new(...)
#        storer = HostDiskStorer.new(self)
#        storer.do_something
#        assert_equal 'expected', log.spied
#      end
#    end
#
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
