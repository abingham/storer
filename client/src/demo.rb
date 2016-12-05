require 'sinatra'
require 'sinatra/base'

require_relative './storer_http_adapter'

class Demo < Sinatra::Base

  get '/' do
  end

  private

  def storer
    StorerHttpAdapter.new
  end

end


