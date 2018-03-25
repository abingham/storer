require_relative 'externals'
require 'json'
require 'rack'

class RackDispatcher

  def call(env)
    request = Rack::Request.new(env)
    name, args = name_args(request)
    triple({ name => storer.send(name, *args) })
  rescue Exception => error
    triple({ 'exception' => error.message })
  end

  private

  include Externals

  def name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @json_args = JSON.parse(request.body.read)
    args = case name
      when /^kata_create$/          then [manifest]
      when /^kata_exists$/,
           /^kata_manifest$/,
           /^kata_increments$/      then [kata_id]

      when /^katas_completed$/,
           /^katas_completions$/    then [partial_id]

      when /^avatars_started$/      then [kata_id]

      when /^avatar_start$/         then [kata_id, avatar_names]
      when /^avatar_exists$/,
           /^avatar_increments$/,
           /^avatar_visible_files$/ then [kata_id, avatar_name]
      when /^avatar_ran_tests$/     then [kata_id, avatar_name, files, now, stdout, stderr, colour]

      when /^tag_fork$/             then [kata_id, avatar_name, tag, now]
      when /^tag_visible_files$/    then [kata_id, avatar_name, tag]

      when /^tags_visible_files$/   then [kata_id, avatar_name, was_tag, now_tag]
    end
    name += '?' if query?(name)
    [name, args]
  end

  # - - - - - - - - - - - - - - - -

  def query?(name)
    name.end_with?('_exists')
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
  request_args :partial_id
  request_args :kata_id, :avatar_name, :avatar_names
  request_args :files, :now, :stdout, :stderr, :colour, :tag
  request_args :was_tag, :now_tag

end
