require_relative './nearest_external'
#require_relative './storer_error'

class HostDiskStorer

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

end
