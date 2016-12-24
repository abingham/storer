require 'sinatra/base'
require 'json'

require_relative './externals'
require_relative './host_disk_storer'

class MicroService < Sinatra::Base

  get '/path' do
    getter(__method__)
  end

  # - - - - - - - - - - - - - - -

  post '/create_kata' do
    poster(__method__, manifest)
  end

  get '/kata_manifest' do
    getter(__method__, kata_id)
  end

  # - - - - - - - - - - - - - - -

  get '/completed' do
    getter(__method__, id)
  end

  get '/completions' do
    getter(__method__, id)
  end

  # - - - - - - - - - - - - - - -

  post '/start_avatar' do
    poster(__method__, kata_id, avatar_names)
  end

  get '/started_avatars' do
    getter(__method__, kata_id)
  end

  # - - - - - - - - - - - - - - -

  post '/avatar_ran_tests' do
    poster(__method__, kata_id, avatar_name, files, now, output, colour)
  end

  # - - - - - - - - - - - - - - -

  get '/avatar_increments' do
    getter(__method__, kata_id, avatar_name)
  end

  get '/avatar_visible_files' do
    getter(__method__, kata_id, avatar_name)
  end

  # - - - - - - - - - - - - - - -

  get '/tag_visible_files' do
    getter(__method__, kata_id, avatar_name, tag)
  end

  get '/tags_visible_files' do
    getter(__method__, kata_id, avatar_name, was_tag, now_tag)
  end

  private

  def getter(name, *args)
    storer_json('GET /', name, *args)
  end

  def poster(name, *args)
    storer_json('POST /', name, *args)
  end

  def storer_json(prefix, caller, *args)
    name = caller.to_s[prefix.length .. -1]
    storer = HostDiskStorer.new(self)
    { name => storer.send(name, *args) }.to_json
  rescue Exception => e
    log << "EXCEPTION: #{e.class.name} #{e.to_s}"
    { 'exception' => e.message }.to_json
  end

  # - - - - - - - - - - - - - - - -

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { args[name.to_s] }
    }
  end

  request_args :manifest, :id
  request_args :kata_id, :avatar_names, :avatar_name
  request_args :files, :now, :output, :colour, :tag
  request_args :was_tag, :now_tag

  def args
    @args ||= JSON.parse(request_body_args)
  end

  def request_body_args
    request.body.rewind
    request.body.read
  end

end
