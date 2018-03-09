require_relative 'bash_sheller'
require_relative 'disk_writer'
require_relative 'id_generator'
require_relative 'kata_id_generator'
require_relative 'stdout_logger'
require_relative 'storer'

module Externals

  def disk
    @disk ||= DiskWriter.new(self)
  end

  def id_generator
    @id ||= IdGenerator.new
  end

  def kata_id_generator
    @kata_id_generator ||= KataIdGenerator.new(self)
  end

  def log
    @log ||= StdoutLogger.new(self)
  end

  def shell
    @shell ||= BashSheller.new(self)
  end

  def storer
    @storer ||= Storer.new(self)
  end

end
