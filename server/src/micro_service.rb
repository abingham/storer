require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  def getter(caller, *args)
    caller = caller.to_s
    method_name = caller['GET /'.length .. -1]
    json_key = method_name
    json_key = json_key.chomp('?') if json_key.end_with?('?')
    puts "http:get----------"
    puts ":#{method_name}:"
    puts ":#{json_key}:" #
    puts "http:get----------"
    json_value = storer.send(method_name, *args)

    { json_key => json_value }.to_json
  end

  # - - - - - - - - - - - - - - - -

  get '/kata_exists' do
    getter(__method__, kata_id)
  end

  post '/create_kata' do
    jasoned(0) { storer.create_kata(manifest) }
    #http(__method__, manifest)
  end

  get '/kata_manifest' do
    jasoned(:kata_manifest) { JSON.parse(storer.kata_manifest(kata_id)) }
  end

  get '/completed' do
    getter(__method__, id)
  end

  get '/ids_for' do
    getter(__method__, id)
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
    when :kata_exists
      return { kata_exists:yield }.to_json
    when :kata_manifest
      return { kata_manifest:yield }.to_json
    when :completed
      return { completed:yield }.to_json
    when :ids_for
      return { ids_for:yield }.to_json

      #when :status
      #return { status:yield }.to_json
      #when :stdout
      #return { stdout:yield }.to_json
    end
  rescue StandardError => e
    return { stdout:'', stderr:e.to_s, status:1 }.to_json
  end

end
