require_relative 'externals'
require 'json'

class MicroService

  def call(env)
    request = Rack::Request.new(env)
    @args = JSON.parse(request.body.read)
    case request.path_info
      when /path/
        body = invoke('path')
      when /kata_exists?/
        body = invoke('kata_exists?', kata_id)
      when /create_kata/
        body = invoke('create_kata', manifest)
      when /kata_manifest/
        body = invoke('kata_manifest', kata_id)
      when /kata_increments/
        body = invoke('kata_increments', kata_id)
      when /completed/
        body = invoke('completed', kata_id)
      when /completions/
        body = invoke('completions', kata_id)
      when /avatar_exists?/
        body = invoke('avatar_exists?', kata_id, avatar_name)
      when /start_avatar/
        body = invoke('start_avatar', kata_id, avatar_names)
      when /started_avatars/
        body = invoke('started_avatars', kata_id)
      when /avatar_ran_tests/
        body = invoke('avatar_ran_tests', kata_id, avatar_name, files, now, output, colour)
      when /avatar_increments/
        body = invoke('avatar_increments', kata_id, avatar_name)
      when /avatar_visible_files/
        body = invoke('avatar_visible_files', kata_id, avatar_name)
      when /tag_visible_files/
        body = invoke('tag_visible_files', kata_id, avatar_name, tag)
      when /tags_visible_files/
        body = invoke('tags_visible_files', kata_id, avatar_name, was_tag, now_tag)
    end
    [ 200, { 'Content-Type' => 'application/json' }, [ body.to_json ] ]
  end

  private

  def invoke(name, *args)
    storer = HostDiskStorer.new(self)
    { name => storer.send(name, *args) }
  rescue Exception => e
    log << "EXCEPTION: #{e.class.name}.#{caller} #{e.message}"
    { 'exception' => e.message }
  end

  # - - - - - - - - - - - - - - - -

  include Externals

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @args[name.to_s] }
    }
  end

  request_args :manifest
  request_args :kata_id, :avatar_name, :avatar_names
  request_args :files, :now, :output, :colour, :tag
  request_args :was_tag, :now_tag

end
