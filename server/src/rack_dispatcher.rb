require_relative 'client_error'
require_relative 'well_formed_args'
require 'json'

class RackDispatcher

  def initialize(storer, request)
    @storer = storer
    @request = request
  end

  # - - - - - - - - - - - - - - - -

  def call(env)
    request = @request.new(env)
    name, args = validated_name_args(request)
    result = @storer.send(name, *args)
    json_triple(200, { name => result })
  rescue => error
    info = {
      'exception' => {
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
    $stderr.puts JSON.pretty_generate(info)
    $stderr.flush
    json_triple(code_400_500(error), info)
  end

  private # = = = = = = = = = = = =

  def validated_name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @well_formed_args = WellFormedArgs.new(request.body.read)
    args = case name
      when /^sha$/                  then []
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
        raise ClientError, 'json:malformed'
    end
    name += '?' if query?(name)
    [name, args]
  end

  private # - - - - - - - - - - - - - - - -

  def json_triple(n, body)
    [ n, { 'Content-Type' => 'application/json' }, [ to_json(body) ] ]
  end

  def to_json(o)
    JSON.pretty_generate(o)
  end

  def code_400_500(error)
    error.is_a?(ClientError) ? 400 : 500
  end

  # - - - - - - - - - - - - - - - -

  def self.well_formed_args(*names)
      names.each do |name|
        define_method name, &lambda { @well_formed_args.send(name) }
      end
  end

  well_formed_args :manifest
  well_formed_args :kata_id, :partial_id, :outer_id
  well_formed_args :avatars_names, :avatar_name
  well_formed_args :files, :now, :stdout, :stderr, :colour
  well_formed_args :tag, :was_tag, :now_tag

  # - - - - - - - - - - - - - - - -

  def query?(name)
    name.end_with?('_exists')
  end

end
