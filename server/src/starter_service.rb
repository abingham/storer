require_relative 'http_json_service'

class StarterService

  def initialize(_)
  end

  def language_manifest(major_name, minor_name, exercise_name)
    get([major_name, minor_name, exercise_name], __method__)
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
