require_relative 'nearest_ancestors'
require 'open3'

class BashSheller

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def cd_exec(path, command, logging = true)
    exec("cd #{path} && #{command}", logging)
  end

  def exec(command, logging = true)
    begin
      stdout,stderr,r = Open3.capture3(command)
      status = r.exitstatus
      if status != success && logging
        log << line
        log << "COMMAND:#{command}"
        log << "STATUS:#{status}"
        log << "STDOUT:#{stdout}"
        log << "STDERR:#{stderr}"
      end
      [stdout,stderr,status]
    rescue StandardError => error
      log << line
      log << "COMMAND:#{command}"
      log << "RAISED-CLASS:#{error.class.name}"
      log << "RAISED-TO_S:#{error.to_s}"
      raise error
    end
  end

  def success; 0; end

  private

  include NearestAncestors
  def log; nearest_ancestors(:log); end

  def line; '-' * 40; end
end
