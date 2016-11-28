require 'sinatra/base'
require 'json'

#require_relative './externals'
#require_relative './storer'

class MicroService < Sinatra::Base

  private

  def args; @args ||= request_body_args; end

  def request_body_args
    request.body.rewind
    JSON.parse(request.body.read)
  end

end
