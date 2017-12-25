require_relative 'bash_sheller'
require_relative 'disk_writer'
require_relative 'stdout_logger'

module Externals

  def disk
    @disk ||= DiskWriter.new(self)
  end

  def log
    @log ||= StdoutLogger.new(self)
  end

  def shell
    @shell ||= BashSheller.new(self)
  end

end
