require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base




  private

  include Externals
  def storer; HostDiskStorer.new(self); end

  def args; @args ||= request_body_args; end

  def request_body_args
    request.body.rewind
    JSON.parse(request.body.read)
  end

end
