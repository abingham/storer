
require_relative './nearest_external'

class ExternalGitter

  def initialize(parent)
    @parent = parent
  end

  # queries

  attr_reader :parent

  def show(path, options)
    output_of(path, "git show #{options}")
  end

  private

  def output_of(path, command)
    stdout,_stderr,_status = shell.cd_exec(path, command)
    stdout
  end

  def shell; nearest_external(:shell); end
  include NearestExternal

end
