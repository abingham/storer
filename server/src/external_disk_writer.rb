
require_relative './nearest_external'

class ExternalDiskWriter

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def [](dir_name)
    ExternalDirWriter.new(@parent, dir_name)
  end

end

# - - - - - - - - - - - - - - - - - - - - -

class ExternalDirWriter

  def initialize(parent, name)
    @parent = parent
    @name = name
  end

  attr_reader :parent, :name

  def make
    # Can't find a Ruby library method allowing you to do a
    # mkdir_p and know if a dir was created or not. So using shell.
    # -p creates intermediate dirs as required.
    # -v verbose mode, output each dir actually made
    output,_exit_status = shell.exec("mkdir -vp #{name}")
    output != ''
  end

  def exists?(filename = nil)
    return File.directory?(name) if filename.nil?
    return File.exists?(pathed(filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def write(filename, content)
    File.open(pathed(filename), 'w') { |fd| fd.write(content) }
  end

  def read(filename)
    IO.read(pathed(filename))
  end

  private

  def pathed(filename)
    name + '/' + filename
  end

  def shell; nearest_external(:shell); end

  include NearestExternal

end
