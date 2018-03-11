require_relative 'externals'
require 'json'
require 'rack'

class RackDispatcher

  def call(env)
    request = Rack::Request.new(env)
    name, args = validated_name_args(request)
    triple({ name => storer.send(name, *args) })
  rescue Exception => error
    triple({ 'exception' => error.message })
  end

  private

  include Externals

  def validated_name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @json_args = JSON.parse(request.body.read)
    args = case name
      when /^create_kata$/          then [manifest]
      when /^kata_exists$/          then [kata_id]
      when /^kata_manifest$/        then [kata_id]
      when /^kata_increments$/      then [kata_id]
      when /^completed$/            then [kata_id]
      when /^completions$/          then [kata_id]
      when /^started_avatars$/      then [kata_id]
      when /^start_avatar$/         then [kata_id, avatar_names]
      when /^avatar_exists$/        then [kata_id, avatar_name]
      when /^avatar_increments$/    then [kata_id, avatar_name]
      when /^avatar_visible_files$/ then [kata_id, avatar_name]
      when /^avatar_ran_tests$/     then [kata_id, avatar_name, files, now, output, colour]
      when /^tag_visible_files$/    then [kata_id, avatar_name, tag]
      when /^tags_visible_files$/   then [kata_id, avatar_name, was_tag, now_tag]
    end
    if name == 'kata_exists'
      name += '?'
    end
    if name == 'avatar_exists'
      name += '?'
    end
    [name, args]
  end

  # - - - - - - - - - - - - - - - -

  def triple(body)
    [ 200, { 'Content-Type' => 'application/json' }, [ body.to_json ] ]
  end

  # - - - - - - - - - - - - - - - -

  def self.request_args(*names)
    names.each { |name|
      define_method name, &lambda { @json_args[name.to_s] }
    }
  end

  request_args :manifest
  request_args :kata_id, :avatar_name, :avatar_names
  request_args :files, :now, :output, :colour, :tag
  request_args :was_tag, :now_tag

end
