require_relative 'bash_sheller'
require_relative 'disk_writer'
require_relative 'stdout_logger'

module Externals

  def shell
    @shell ||= BashSheller.new(self)
  end

  def disk
    @disk ||= DiskWriter.new(self)
  end

  def log
    @log ||= StdoutLogger.new(self)
  end

end
