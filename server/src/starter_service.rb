require_relative 'http_json_service'

class StarterService

  def initialize(_)
  end

  def manifest(old_name)
    get([old_name], __method__)
  end

  private

  include HttpJsonService

  def hostname
    'starter'
  end

  def port
    4527
  end

end
