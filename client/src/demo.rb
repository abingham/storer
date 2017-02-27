require_relative 'storer_service'
require 'sinatra/base'

class Demo < Sinatra::Base

  get '/' do
  end

  private

  def storer
    StorerService.new
  end

end


