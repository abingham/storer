require_relative './nearest_external'
#require_relative './storer_error'

class HostDiskStorer

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def path
    @path ||= ENV['CYBER_DOJO_KATAS_ROOT']
  end



  private

  def disk; nearest_external(:disk); end
  def git; nearest_external(:git); end

  include NearestExternal

end
