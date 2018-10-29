require_relative 'dir_writer'

class DiskWriter

  def initialize(external)
    @shell = external.shell
  end

  def [](dir_name)
    DirWriter.new(self, @shell, dir_name)
  end

end
