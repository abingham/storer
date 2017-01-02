require_relative 'nearest_ancestors'

class Gitter

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def show(path, options)
    output_of(path, "git show #{options}")
  end

  private

  def output_of(path, command)
    stdout,_stderr,_status = shell.cd_exec(path, command)
    stdout
  end

  include NearestAncestors
  def shell; nearest_ancestors(:shell); end

end
