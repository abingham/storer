
class DirWriter

  def initialize(parent, shell, name)
    @parent = parent
    @shell = shell
    @name = name
  end

  attr_reader :name

  def make
    # Can't find a Ruby library method allowing you to do a
    # mkdir_p and-know-if-a-dir-was-created-or-not.
    # Note: FileUtils.mkdir_p() does not tell.
    # So using shell.
    # -p creates intermediate dirs as required.
    # -v verbose mode, output each dir actually made
    output,_exit_status = shell.exec("mkdir -vp #{name}")
    output != ''
  end

  def rm
    shell.exec("rm -rf #{name}")
  end

  def exists?(filename = nil)
    if filename.nil?
      File.directory?(name)
    else
      File.exist?(pathed(filename))
    end
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
      if @parent[pathed(entry)].exists? && !dot?(pathed(entry))
        yield entry
      end
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
