require_relative 'all_avatars_names'
require_relative 'base58'
require_relative 'externals'
require 'json'
require 'rack'

class RackDispatcher

  def initialize(request = Rack::Request)
    @request = request
  end

  # - - - - - - - - - - - - - - - -

  def call(env)
    request = @request.new(env)
    name, args = validated_name_args(request)
    triple({ name => storer.send(name, *args) })
  rescue StandardError => error
    triple({ 'exception' => error.message })
  rescue Exception => error
    puts error.message
    puts error.backtrace
    triple({ 'exception' => error.class.name })
  end

  private # = = = = = = = = = = = =

  include AllAvatarsNames
  include Externals

  def validated_name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @json_args = JSON.parse(request.body.read)
    args = case name
      when /^kata_create$/          then [manifest]
      when /^kata_exists$/,
           /^kata_manifest$/,
           /^kata_increments$/      then [kata_id]

      when /^katas_completed$/,
           /^katas_completions$/    then [partial_id]

      when /^avatar_start$/         then [kata_id, avatar_names]
      when /^avatar_exists$/,
           /^avatar_increments$/,
           /^avatar_visible_files$/ then [kata_id, avatar_name]
      when /^avatar_ran_tests$/     then [kata_id, avatar_name, files, now, stdout, stderr, colour]

      when /^avatars_started$/      then [kata_id]

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

  # - - - - - - - - - - - - - - - -
  # method arguments
  # - - - - - - - - - - - - - - - -

  def partial_id
    arg = @json_args['partial_id']
    unless Base58.string?(arg) && arg.length < 10
      malformed('partial_id')
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def kata_id
    arg = @json_args['kata_id']
    unless Base58.string?(arg) && arg.length == 10
      malformed('kata_id')
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def avatar_name
    arg = @json_args['avatar_name']
    unless all_avatars_names.include?(arg)
      malformed('avatar_name')
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def tag
    arg = @json_args['tag']
    unless arg.is_a?(Integer)
      malformed('tag')
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  request_args :manifest
  request_args :avatar_names
  request_args :files, :now, :colour
  request_args :stdout, :stderr
  request_args :was_tag, :now_tag

  # - - - - - - - - - - - - - - - -

  def malformed(name)
    raise ArgumentError.new("#{name}:malformed")
  end

end
