require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  post '/create_kata' do
    poster(__method__, manifest)
  end

  # - - - - - - - - - - - - - - -

  get '/completed' do
    getter(__method__, id)
  end

  get '/completions' do
    getter(__method__, id)
  end

  # - - - - - - - - - - - - - - -

  get '/kata_exists' do
    getter(__method__, kata_id)
  end

  get '/kata_manifest' do
    getter(__method__, kata_id)
  end

  post '/kata_start_avatar' do
    poster(__method__, kata_id, avatar_names)
  end

  get '/kata_started_avatars' do
    getter(__method__, kata_id)
  end

  # - - - - - - - - - - - - - - -

  get '/avatar_increments' do
    getter(__method__, kata_id, avatar_name)
  end

  get '/avatar_visible_files' do
    getter(__method__, kata_id, avatar_name)
  end

  post '/avatar_ran_tests' do
    poster(__method__, kata_id, avatar_name, delta, files, now, output, colour)
  end

  private

  def getter(name, *args)
    httper('GET /', name, *args)
  end

  def poster(name, *args)
    httper('POST /', name, *args)
  end

  def httper(prefix, caller, *args)
    name = caller.to_s[prefix.length .. -1]
    { name => HostDiskStorer.new(self).send(name, *args) }.to_json
  end

  # - - - - - - - - - - - - - - - -

  include Externals

  def self.request_args(*names)
    names.each { |name|  define_method name, &lambda { args[name.to_s] } }
  end

  request_args :kata_id, :manifest, :id, :avatar_names, :avatar_name
  request_args :delta, :files, :now, :output, :colour

  def args; @args ||= request_body_args; end

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
