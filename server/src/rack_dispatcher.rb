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
    @json_args = json_parse(request.body.read)
    args = case name
      when /^kata_create$/          then [manifest]
      when /^kata_exists$/,
           /^kata_manifest$/,
           /^kata_increments$/      then [kata_id]

      when /^katas_completed$/      then [partial_id]
      when /^katas_completions$/    then [outer_id]

      when /^avatar_start$/         then [kata_id, avatars_names]
      when /^avatar_exists$/,
           /^avatar_increments$/,
           /^avatar_visible_files$/ then [kata_id, avatar_name]
      when /^avatar_ran_tests$/     then [kata_id, avatar_name, files, now, stdout, stderr, colour]

      when /^avatars_started$/      then [kata_id]

      when /^tag_fork$/             then [kata_id, avatar_name, tag, now]
      when /^tag_visible_files$/    then [kata_id, avatar_name, tag]

      when /^tags_visible_files$/   then [kata_id, avatar_name, was_tag, now_tag]
      else
        raise ArgumentError.new('unknown-method')
    end
    name += '?' if query?(name)
    [name, args]
  end

  # - - - - - - - - - - - - - - - -

  def json_parse(s)
    JSON.parse(s)
  rescue
    raise ArgumentError.new('!json')
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

  def outer_id
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless Base58.string?(arg) && arg.length == 2
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def partial_id
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless Base58.string?(arg) && (6..10).include?(arg.length)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def kata_id
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless Base58.string?(arg) && arg.length == 10
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def avatars_names
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Array)
      malformed(arg_name)
    end
    unless arg.size > 0
      malformed(arg_name)
    end
    unless arg.all? {|name| all_avatars_names.include?(name) }
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def avatar_name
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless all_avatars_names.include?(arg)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def tag
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Integer)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def was_tag
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Integer)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def now_tag
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Integer)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  request_args :manifest
  request_args :files, :now, :colour
  request_args :stdout, :stderr

  # - - - - - - - - - - - - - - - -

  def malformed(arg_name)
    raise ArgumentError.new("#{arg_name}:malformed")
  end

end
