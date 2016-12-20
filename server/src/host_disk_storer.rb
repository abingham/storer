require_relative 'nearest_external'
require_relative 'all_avatar_names'
require 'json'

class HostDiskStorer

  def initialize(parent)
    @parent = parent
    @path = ENV['CYBER_DOJO_KATAS_ROOT']
  end

  attr_reader :parent, :path

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas

  def completed(id)
    # Used only in enter_controller/check
    # If at least 6 characters of the id are provided attempt to complete
    # it into the full 10 character id. Doing completion with fewer characters
    # would likely result in a lot of disk activity and no unique outcome.
    # Also, if completion was attempted for a very short id (say 3 characters)
    # it would provide a way for anyone to find the full id of a cyber-dojo
    # and potentially interfere with a live session.
    if !id.nil? && id.length >= 6
      outer_dir = disk[dir_join(path, outer(id))]
      if outer_dir.exists?
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(inner(id)) }
        id = outer(id) + dirs[0] if dirs.length == 1
      end
    end
    id || ''
  end

  def completions(outer_dir)
    # for Batch-Method iteration over large number of katas...
    return [] unless disk[dir_join(path, outer_dir)].exists?
    disk[dir_join(path, outer_dir)].each_dir.collect { |dir| dir }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata

  def create_kata(manifest)
    id = manifest['id']
    assert_valid_id(id)
    # a kata's id has 10 hex chars. This gives 16^10 possibilities
    # which is 1,099,511,627,776 which is big enough to not
    # need to check that a kata with the id already exists.
    dir = kata_dir(id)
    dir.make
    dir.write(manifest_filename, JSON.unparse(manifest))
  end

  def kata_manifest(id)
    assert_kata_exists(id)
    JSON.parse(kata_dir(id).read(manifest_filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar-start

  def kata_start_avatar(id, avatar_names)
    assert_kata_exists(id)
    # NB: Doing the & with operands swapped loses randomness
    valid_names = avatar_names & all_avatar_names
    name = valid_names.detect { |name| avatar_dir(id, name).make }
    return nil if name.nil? # full!
    write_avatar_increments(id, name, [])
    name
  end

  def kata_started_avatars(id)
    assert_kata_exists(id)
    started = kata_dir(id).each_dir.collect { |name| name }
    started & all_avatar_names
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar action!

  def avatar_ran_tests(id, name, files, now, output, colour)
    assert_avatar_exists(id, name)
    rags = increments(id, name)
    tag = rags.length + 1
    rags << { 'colour' => colour, 'time' => now, 'number' => tag }
    write_avatar_increments(id, name, rags)

    files = files.clone # don't alter caller's files argument
    files['output'] = output
    write_tag_manifest(id, name, tag, files)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar info

  def avatar_increments(id, name)
    assert_avatar_exists(id, name)
    # Return increments with tag0 to avoid client
    # having to make extra service call
    tag0 =
      {
        'event' => 'created',
        'time' => kata_manifest(id)['created'],
        'number' => 0
      }
    [tag0] + increments(id, name)
  end

  def avatar_visible_files(id, name)
    assert_avatar_exists(id, name)
    rags = increments(id, name)
    tag = rags == [] ? 0 : rags[-1]['number']
    tag_visible_files(id, name, tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag

  def tag_visible_files(id, name, tag)
    assert_kata_exists(id)
    if tag == 0
      kata_manifest(id)['visible_files']
    else
      dir = tag_dir(id, name, tag)
      if dir.exists? # new non-git-format
        src = tag_dir(id, name, tag).read(manifest_filename)
      else # old git-format
        src = git.show(avatar_path(id, name), "#{tag}:#{manifest_filename}")
      end
      JSON.parse(src)
    end
  end

  private

  def kata_dir(id); disk[kata_path(id)]; end
  def kata_path(id); dir_join(path, outer(id), inner(id)); end

  def avatar_dir(id, name); disk[avatar_path(id, name)]; end
  def avatar_path(id, name); dir_join(kata_path(id), name); end

  def tag_dir(id, name, tag); disk[tag_path(id, name, tag)]; end
  def tag_path(id, name, tag); dir_join(avatar_path(id, name), tag.to_s); end

  def dir_join(*args); File.join(*args); end

  # - - - - - - - - - - -

  def outer(id); id.upcase[0..1]; end  # eg 'E5' 2-chars long
  def inner(id); id.upcase[2..-1]; end # eg '6A3327FE' 8-chars long

  # - - - - - - - - - - -

  def increments(id, name)
    # Each avatar's increments stores a cache of colours and time-stamps
    # for all the avatar's [test]s.
    # Helps optimize dashboard traffic-lights views.
    # Do _not_ save tag0 in increments.json
    # to maintain compatibility with old git-format
    JSON.parse(avatar_dir(id, name).read(increments_filename))
  end

  def increments_filename; 'increments.json'; end

  def write_avatar_increments(id, name, increments)
    avatar_dir(id, name).write(increments_filename, JSON.unparse(increments))
  end

  # - - - - - - - - - - -

  def manifest_filename
    # A kata's manifest stores the kata's meta information
    # such as the chosen language, tests, exercise.
    # An avatar's manifest stores avatar's visible-files.
    'manifest.json'
  end

  def write_tag_manifest(id, name, tag, files)
    dir = tag_dir(id, name, tag)
    dir.make
    dir.write(manifest_filename, JSON.unparse(files))
  end

  # - - - - - - - - - - -

  def assert_valid_id(id)
    raise StandardError.new('Storer:invalid id') unless valid_id?(id)
  end

  def assert_valid_avatar(name)
    raise StandardError.new('Storer:invalid name') unless valid_avatar?(name)
  end

  def assert_kata_exists(id)
    assert_valid_id(id)
    raise StandardError.new('Storer.invalid id') unless kata_exists?(id)
  end

  def assert_avatar_exists(id, name)
    assert_kata_exists(id)
    assert_valid_avatar(name)
    raise StandardError.new('Storer.invalid name') unless avatar_exists?(id, name)
  end

  # - - - - - - - - - - -

  def valid_id?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

  def valid_avatar?(name)
    all_avatar_names.include?(name)
  end

  def kata_exists?(id)
    kata_dir(id).exists?
  end

  def avatar_exists?(id, name)
    avatar_dir(id, name).exists?
  end

  # - - - - - - - - - - -

  include AllAvatarNames

  include NearestExternal
  def disk; nearest_external(:disk); end
  def git; nearest_external(:git); end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo its initial "tag-zero"
# is *not* recorded in its increments.json file which starts as [ ]
# It probably should be but isn't for existing dojos
# (created in the old git format) and so for backwards
# compatibility it stays that way.
#
# Every test event stores an entry in the increments.json file.
# eg
# [
#   {
#     'colour' => 'red',
#     'time'   => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
#
# At the moment the only event that creates an
# increments.json file entry is a [test].
#
# However, it's conceivable I may create finer grained tags
# than just [test] events, eg
#    o) creating a new file
#    o) renaming a file
#    o) deleting a file
#    o) opening a different file
#    o) editing a file
#
# If this happens the difference between tags and lights
# will be more pronounced.
# ------------------------------------------------------
