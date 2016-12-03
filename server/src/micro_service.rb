require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  get '/kata_exists' do
    jasoned(1) { storer.kata_exists?(kata_id) }
  end



  private

  include Externals
  def storer; HostDiskStorer.new(self); end

  def args; @args ||= request_body_args; end

  def kata_id; args['kata_id']; end

  def request_body_args
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def jasoned(n)
    content_type :json
    case n
    when 1
      return { status:yield }.to_json
    end
  #rescue DockerRunnerError => e
    #return { stdout:e.stdout, stderr:e.stderr, status:e.status }.to_json
  rescue StandardError => e
    return { stdout:'', stderr:e.to_s, status:1 }.to_json
  end

end
