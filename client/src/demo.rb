require 'sinatra'
require 'sinatra/base'

require_relative './storer_service'

class Demo < Sinatra::Base

  get '/' do
  end

  private

  def storer
    StorerService.new
  end

end


