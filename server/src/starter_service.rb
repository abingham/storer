require_relative 'http_json_service'

class StarterService

  def manifest(old_name)
    get([old_name], __method__)
  end

  private

  include HttpJsonService

  def hostname
    #ENV['CYBER_DOJO_STARTER_SERVER_NAME']
  end

  def port
    #ENV['CYBER_DOJO_STARTER_SERVER_PORT']
  end

end
