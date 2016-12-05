require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  get '/kata_exists' do
    getter(__method__, kata_id)
  end

  post '/create_kata' do
    poster(__method__, manifest)
  end

  get '/kata_manifest' do
    getter(__method__, kata_id)
  end

  get '/completed' do
    getter(__method__, id)
  end

  get '/ids_for' do
    getter(__method__, id)
  end

  get '/kata_started_avatars' do
    getter(__method__, kata_id)
  end

  private

  def getter(caller, *args)
    name = caller.to_s['GET /'.length .. -1]
    { name => storer.send(name, *args) }.to_json
  end

  def poster(caller, *args)
    name = caller.to_s['POST /'.length .. -1]
    storer.send(name, *args)
    {}.to_json
  end

  # - - - - - - - - - - - - - - - -

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

  #def jasoned(n)
  #  content_type :json
  #rescue StandardError => e
  #  return { stdout:'', stderr:e.to_s, status:1 }.to_json
  #end

end
