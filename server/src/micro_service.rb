require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  get '/kata_exists' do
    jasoned(1) { storer.kata_exists?(kata_id) }
  end

  post '/create_kata' do
    jasoned(1) { storer.create_kata(manifest); }
  end

  private

  include Externals
  def storer; HostDiskStorer.new(self); end

  def args; @args ||= request_body_args; end

  def kata_id;  args['kata_id' ]; end
  def manifest; args['manifest']; end

  def request_body_args
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def jasoned(n)
    content_type :json
    case n
    when 1
      return { status:yield }.to_json
    when 3
      stdout,stderr,status = yield
      return { stdout:stdout, stderr:stderr, status:status }.to_json
    end
  rescue StandardError => e
    return { stdout:'', stderr:e.to_s, status:1 }.to_json
  end

end
