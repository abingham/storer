
class DiskWriter

  def initialize(external)
    @shell = external.shell
  end

  def [](dir_name)
    DirWriter.new(self, @shell, dir_name)
  end

end

# - - - - - - - - - - - - - - - - - - - - -

class DirWriter

  def initialize(parent, shell, name)
    @parent = parent
    @shell = shell
    @name = name
  end

  attr_reader :name

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
    return File.exist?(pathed(filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def write(filename, content)
    File.open(pathed(filename), 'w') { |fd| fd.write(content) }
  end

  def read(filename)
    IO.read(pathed(filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def each_dir
    return enum_for(:each_dir) unless block_given?
    Dir.entries(name).each do |entry|
      yield entry if @parent[pathed(entry)].exists? && !dot?(pathed(entry))
    end
  end

  private

  attr_reader :shell

  def pathed(entry)
    name + '/' + entry
  end

  def dot?(name)
    name.end_with?('/.') || name.end_with?('/..')
  end

end
