require_relative 'all_avatars_names'
require_relative 'base58'

module WellFormedArgs

  include AllAvatarsNames

  def manifest
    arg_name = __method__.to_s
    @json_args[arg_name]
  end

  def Xmanifest
    known_keys = %w(
        display_name
        visible_filenames
        image_name
        runner_choice
        filename_extension
        highlight_filenames
        progress_regexs
        tab_size
        max_seconds
      )
    # display_name: String
    # visible_files: Array of String
    # image_name: String
    # runner_choice: String (two options)
    #
    # filename_extension: String
    # highlight_filenames: Array of String
    # progress_regexs: Array of 2 Strings
    # tab_size: Integer
    # max_seconds: Integer

  end

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

  def stdout
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(String)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def stderr
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(String)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def files
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Hash)
      malformed(arg_name)
    end
    arg.values.each do |value|
      unless value.is_a?(String)
        malformed(arg_name)
      end
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def colour
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless ['red','amber','green','timed_out'].include?(arg)
      malformed(arg_name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def now
    arg_name = __method__.to_s
    arg = @json_args[arg_name]
    unless arg.is_a?(Array)
      malformed(arg_name)
    end
    Time.mktime(*arg)
    arg
  rescue ArgumentError
    malformed(arg_name)
  end

  # - - - - - - - - - - - - - - - -

  def malformed(arg_name)
    raise ArgumentError.new("#{arg_name}:malformed")
  end

end