require_relative 'client_error'
require_relative 'well_formed_args'
require 'json'

class RackDispatcher

  def initialize(storer, request_class)
    @storer = storer
    @request_class = request_class
  end

  # - - - - - - - - - - - - - - - -

  def call(env)
    request = @request_class.new(env)
    path = request.path_info[1..-1] # lose leading /
    body = request.body.read
    name, args = validated_name_args(path, body)
    result = @storer.public_send(name, *args)
    json_response(200, plain({ name => result }))
  rescue => error
    diagnostic = pretty({
      'exception' => {
        'path' => path,
        'body' => body,
        'class' => 'StorerService',
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    })
    $stderr.puts(diagnostic)
    $stderr.flush
    json_response(code(error), diagnostic)
  end

  private # = = = = = = = = = = = =

  def validated_name_args(name, body)
    @well_formed_args = WellFormedArgs.new(body)
    args = case name
      when /^sha$/                  then []
      when /^kata_create$/          then [manifest]
      when /^kata_delete$/,
           /^kata_exists$/,
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

  def json_response(status, body)
    [ status, { 'Content-Type' => 'application/json' }, [ body ] ]
  end

  def plain(body)
    JSON.generate(body)
  end

  def pretty(o)
    JSON.pretty_generate(o)
  end

  def code(error)
    if error.is_a?(ClientError)
      400 # client_error
    else
      500 # server_error
    end
  end

  # - - - - - - - - - - - - - - - -

  def self.well_formed_args(*names)
    names.each do |name|
      define_method name, &lambda { @well_formed_args.send(name) }
    end
  end

  well_formed_args :manifest,
                   :kata_id, :partial_id, :outer_id,
                   :avatars_names, :avatar_name,
                   :files, :now, :stdout, :stderr, :colour,
                   :tag, :was_tag, :now_tag

  # - - - - - - - - - - - - - - - -

  def query?(name)
    name.end_with?('_exists')
  end

end
