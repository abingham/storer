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

  def kata_exists?(id)
    valid?(id) && kata_dir(id).exists?
  end

  #...

  private

  def kata_dir(id)
    disk[kata_path(id)]
  end

  def kata_path(id)
    path + '/' + outer(id) + '/' + inner(id)
  end

  def valid?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

  def outer(id)
    id.upcase[0..1]  # 'E5'
  end

  def inner(id)
    id.upcase[2..-1] # '6A3327FE'
  end

  def disk; nearest_external(:disk); end
  #def git; nearest_external(:git); end

  include NearestExternal

end
