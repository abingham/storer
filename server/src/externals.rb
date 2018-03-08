require_relative 'bash_sheller'
require_relative 'disk_writer'
require_relative 'stdout_logger'
require_relative 'kata_id_factory'

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

  def id_factory
    @id_factory ||= KataIdFactory.new(self)
  end

end
