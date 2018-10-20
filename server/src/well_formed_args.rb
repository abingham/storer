require_relative 'all_avatars_names'
require_relative 'base58'
require 'json'

# Checks for arguments syntactic correctness

class WellFormedArgs

  def initialize(s)
    @args = JSON.parse(s)
  rescue
    raise ArgumentError.new('json:malformed')
  end

  # - - - - - - - - - - - - - - - -

  def manifest
    @arg_name = __method__.to_s

    malformed unless arg.is_a?(Hash)
    malformed unless all_required_keys?
    malformed if     any_unknown_key?

    arg.keys.each do |key|
      value = arg[key]
      case key
      when 'display_name', 'image_name', 'runner_choice', 'exercise'
        malformed unless value.is_a?(String)
      when 'visible_files'
        malformed unless value.is_a?(Hash)
        value.each { |_filename,content| malformed unless content.is_a?(String) }
      when 'highlight_filenames','progress_regexs','hidden_filenames'
        malformed unless value.is_a?(Array)
        value.each { |val|  malformed unless val.is_a?(String) }
      when 'tab_size', 'max_seconds'
        malformed unless value.is_a?(Integer)
      when 'created'
        malformed unless is_time?(value)
      when 'filename_extension'
        value = [ value ] if value.is_a?(String)
        malformed unless value.is_a?(Array)
        value.each { |val| malformed unless val.is_a?(String) }
      end
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def outer_id
    @arg_name = __method__.to_s
    malformed unless Base58.string?(arg) && arg.length == 2
    arg
  end

  # - - - - - - - - - - - - - - - -

  def partial_id
    @arg_name = __method__.to_s
    malformed unless Base58.string?(arg) && (6..10).include?(arg.length)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def kata_id
    @arg_name = __method__.to_s
    malformed unless Base58.string?(arg) && arg.length == 10
    arg
  end

  # - - - - - - - - - - - - - - - -

  def avatars_names
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Array)
    malformed unless arg.size > 0
    malformed unless arg.all? {|name| all_avatars_names.include?(name) }
    arg
  end

  # - - - - - - - - - - - - - - - -

  def avatar_name
    @arg_name = __method__.to_s
    malformed unless all_avatars_names.include?(arg)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def tag
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Integer)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def was_tag
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Integer)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def now_tag
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Integer)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def stdout
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(String)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def stderr
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(String)
    arg
  end

  # - - - - - - - - - - - - - - - -

  def files
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Hash)
    arg.values.each do |value|
      malformed unless value.is_a?(String)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def colour
    @arg_name = __method__.to_s
    unless ['red','amber','green','timed_out'].include?(arg)
      malformed
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def now
    @arg_name = __method__.to_s
    malformed unless arg.is_a?(Array)
    malformed unless arg.length == 6
    malformed unless arg.all?{ |n| n.is_a?(Integer) }
    Time.mktime(*arg)
    arg
  rescue ArgumentError
    malformed
  end

  private # = = = = = = = = = = = =

  attr_reader :args, :arg_name

  def arg
    args[arg_name]
  end

  # - - - - - - - - - - - - - - - -

  def all_required_keys?
    REQUIRED_KEYS.all? { |required_key| arg.keys.include?(required_key) }
  end

  REQUIRED_KEYS = %w(
    display_name
    visible_files
    image_name
    runner_choice
    created
  )

  # - - - - - - - - - - - - - - - -

  def any_unknown_key?
    arg.keys.any? { |key| !KNOWN_KEYS.include?(key) }
  end

  KNOWN_KEYS = REQUIRED_KEYS + %w(
    exercise
    filename_extension
    highlight_filenames
    hidden_filenames
    progress_regexs
    tab_size
    max_seconds
  )

  # - - - - - - - - - - - - - - - -

  def is_time?(arg)
    return false unless arg.is_a?(Array)
    return false unless arg.size == 6
    return false unless arg.all? { |n| n.is_a?(Integer) }
    Time.mktime(*arg)
    true
  rescue
    false
  end

  # - - - - - - - - - - - - - - - -

  def malformed
    raise ArgumentError.new("#{arg_name}:malformed")
  end

  include AllAvatarsNames

end
