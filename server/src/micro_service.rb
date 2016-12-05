require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  get '/kata_exists' do
    jasoned(:status) { storer.kata_exists?(kata_id) }
  end

  post '/create_kata' do
    jasoned(0) { storer.create_kata(manifest) }
  end

  get '/kata_manifest' do
    jasoned(:stdout) { storer.kata_manifest(kata_id) }
  end

  get '/completed' do
    jasoned(:stdout) { storer.completed(id) }
  end

  private

  include Externals
  def storer; HostDiskStorer.new(self); end

  def args; @args ||= request_body_args; end

  def kata_id;  args['kata_id' ]; end
  def manifest; args['manifest']; end
  def      id;  args['id'      ]; end

  def request_body_args
    request.body.rewind
    JSON.parse(request.body.read)
  end

  def jasoned(n)
    content_type :json
    case n
    when 0
      yield; return { status:0 }.to_json
    when :status
      return { status:yield }.to_json
    when :stdout
      return { stdout:yield }.to_json
    end
  rescue StandardError => e
    return { stdout:'', stderr:e.to_s, status:1 }.to_json
  end

end
