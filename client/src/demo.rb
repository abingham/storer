require 'sinatra'
require 'sinatra/base'

require_relative './storer_post_adapter'

class Demo < Sinatra::Base

  get '/' do
  end

  private

  def storer
    StorerPostAdapter.new
  end

end


