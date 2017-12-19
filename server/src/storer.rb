require_relative 'all_avatars_names'
require 'json'

class Storer

  def initialize(external)
    @disk = external.disk
    @shell = external.shell
    @path = ENV['CYBER_DOJO_KATAS_ROOT']
  end

  attr_reader :path

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata-id completion(s)

  def completed(kata_id)
    assert_partial_id(kata_id)
    # If at least 6 characters of the kata_id are provided
    # attempt to complete it into the full characters. Doing
    # completion with fewer characters would likely result in
    # a lot of disk activity and no unique outcome. Also, if
    # completion was attempted for a very short id (say 3
    # characters) it would provide a way for anyone to find
    # the full id of a cyber-dojo and potentially interfere
    # with a live session.
    unless kata_id.length >= 6
      return kata_id
    end
    outer_dir = disk[dir_join(path, outer(kata_id))]
    unless outer_dir.exists?
      return kata_id
    end
    dirs = outer_dir.each_dir.select { |inner_dir|
      inner_dir.start_with?(inner(kata_id))
    }
    unless dirs.length == 1
      return kata_id
    end
    outer(kata_id) + dirs[0] # success!
  end

  def completions(kata_id) # 2-chars long
    # for Batch-Method iteration over large number of katas...
    unless disk[dir_join(path, kata_id)].exists?
      return []
    end
    disk[dir_join(path, kata_id)].each_dir.collect { |dir| dir }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata

  def kata_exists?(kata_id)
    unless valid_id?(kata_id)
      return false
    end
    kata_dir(kata_id).exists?
  end

  def create_kata(manifest)
    kata_id = manifest['id']
    assert_valid_id(kata_id)
    refute_kata_exists(kata_id)
    json = JSON.unparse(manifest)
    dir = kata_dir(kata_id)
    dir.make
    dir.write(manifest_filename, json)
  end

  def kata_manifest(kata_id)
    assert_kata_exists(kata_id)
    dir = kata_dir(kata_id)
    json = dir.read(manifest_filename)
    JSON.parse(json)
  end

  def kata_increments(kata_id)
    incs = {}
    started_avatars(kata_id).each do |name|
      incs[name] = avatar_increments(kata_id, name)
    end
    incs
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar start

  def avatar_exists?(kata_id, avatar_name)
    assert_kata_exists(kata_id)
    assert_valid_name(avatar_name)
    avatar_dir(kata_id, avatar_name).exists?
  end

  def start_avatar(kata_id, avatar_names)
    assert_kata_exists(kata_id)
    # NB: Doing & with swapped args loses randomness!
    valid_names = avatar_names & all_avatars_names
    avatar_name = valid_names.detect { |name|
      avatar_dir(kata_id, name).make
    }
    if avatar_name.nil? # full!
      return nil
    end
    write_avatar_increments(kata_id, avatar_name, [])
    avatar_name
  end

  def started_avatars(kata_id)
    assert_kata_exists(kata_id)
    started = kata_dir(kata_id).each_dir.collect { |name| name }
    started & all_avatars_names
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar action!

  def avatar_ran_tests(kata_id, avatar_name, files, now, output, colour)
    assert_avatar_exists(kata_id, avatar_name)
    increments = read_avatar_increments(kata_id, avatar_name)
    tag = increments.length + 1
    increments << { 'colour' => colour, 'time' => now, 'number' => tag }
    write_avatar_increments(kata_id, avatar_name, increments)

    files = files.clone # don't alter caller's files argument
    files['output'] = output
    write_tag_files(kata_id, avatar_name, tag, files)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar info

  def avatar_increments(kata_id, avatar_name)
    assert_avatar_exists(kata_id, avatar_name)
    # Return increments with tag0 to avoid client
    # having to make extra service call
    tag0 =
      {
         'event' => 'created',
          'time' => kata_manifest(kata_id)['created'],
        'number' => 0
      }
    [tag0] + read_avatar_increments(kata_id, avatar_name)
  end

  def avatar_visible_files(kata_id, avatar_name)
    assert_avatar_exists(kata_id, avatar_name)
    rags = read_avatar_increments(kata_id, avatar_name)
    tag = (rags == []) ? 0 : rags[-1]['number']
    tag_visible_files(kata_id, avatar_name, tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag

  def tag_visible_files(kata_id, avatar_name, tag)
    assert_tag_exists(kata_id, avatar_name, tag)
    if tag == 0 # tag zero is a special case
      return kata_manifest(kata_id)['visible_files']
    end
    dir = tag_dir(kata_id, avatar_name, tag)
    if dir.exists? # new non-git-format
      read_tag_files(kata_id, avatar_name, tag)
    else # old git-format
      path = avatar_path(kata_id, avatar_name)
      git = "git show #{tag}:#{manifest_filename}"
      src = shell.cd_exec(path, git)[0]
      JSON.parse(src)
    end
  end

  def tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
    {
      'was_tag' => tag_visible_files(kata_id, avatar_name, was_tag),
      'now_tag' => tag_visible_files(kata_id, avatar_name, now_tag)
    }
  end

  def tag_fork(kata_id, avatar_name, tag)
    assert_tag_exists(kata_id, avatar_name, tag)
    #TODO
  end

  private

  attr_reader :disk, :shell

  def write_avatar_increments(kata_id, avatar_name, increments)
    json = JSON.unparse(increments)
    dir = avatar_dir(kata_id, avatar_name)
    dir.write(increments_filename, json)
  end

  def read_avatar_increments(kata_id, avatar_name)
    # Each avatar's increments stores a cache of colours
    # and time-stamps for all the avatar's [test]s.
    # Helps optimize dashboard traffic-lights views.
    # Not saving tag0 in increments.json
    # to maintain compatibility with old git-format
    dir = avatar_dir(kata_id, avatar_name)
    json = dir.read(increments_filename)
    JSON.parse(json)
  end

  def increments_filename
    'increments.json'
  end

  # - - - - - - - - - - -

  def write_tag_files(kata_id, avatar_name, tag, files)
    json = JSON.unparse(files)
    dir = tag_dir(kata_id, avatar_name, tag)
    dir.make
    dir.write(manifest_filename, json)
  end

  def read_tag_files(kata_id, avatar_name, tag)
    dir = tag_dir(kata_id, avatar_name, tag)
    json = dir.read(manifest_filename)
    JSON.parse(json)
  end

  def manifest_filename
    # A kata's manifest stores the kata's meta information
    # such as the chosen language, chosen tests framework,
    # chosen exercise.
    # An avatar's manifest stores avatar's visible-files.
    'manifest.json'
  end

  # - - - - - - - - - - -

  def refute_kata_exists(kata_id)
    if kata_exists?(kata_id)
      fail invalid('kata_id')
    end
  end

  def assert_kata_exists(kata_id)
    unless kata_exists?(kata_id)
      fail invalid('kata_id')
    end
  end

  def assert_valid_id(kata_id)
    unless valid_id?(kata_id)
      fail invalid('kata_id')
    end
  end

  def assert_partial_id(kata_id)
    unless partial_id?(kata_id)
      fail invalid('kata_id')
    end
  end

  def valid_id?(kata_id)
    partial_id?(kata_id) && kata_id.length == 10
  end

  def partial_id?(kata_id)
    kata_id.class.name == 'String' &&
      kata_id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

  def kata_dir(kata_id)
    disk[kata_path(kata_id)]
  end

  def kata_path(kata_id)
    dir_join(path, outer(kata_id), inner(kata_id))
  end

  def outer(kata_id)
    kata_id.upcase[0..1]  # eg 'E5' 2-chars long
  end

  def inner(kata_id)
    kata_id.upcase[2..-1] # eg '6A3327FE' 8-chars long
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_avatar_exists(kata_id, avatar_name)
    unless avatar_exists?(kata_id, avatar_name)
      fail invalid('avatar_name')
    end
  end

  def assert_valid_name(avatar_name)
    unless valid_avatar?(avatar_name)
      fail invalid('avatar_name')
    end
  end

  def valid_avatar?(avatar_name)
    all_avatars_names.include?(avatar_name)
  end

  def avatar_dir(kata_id, avatar_name)
    disk[avatar_path(kata_id, avatar_name)]
  end

  def avatar_path(kata_id, avatar_name)
    dir_join(kata_path(kata_id), avatar_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_tag_exists(kata_id, avatar_name, tag)
    assert_avatar_exists(kata_id, avatar_name)
    assert_valid_tag(tag)
    unless tag_exists?(kata_id, avatar_name, tag)
      fail invalid('tag')
    end
  end

  def assert_valid_tag(tag)
    unless valid_tag?(tag)
      fail invalid('tag')
    end
  end

  def valid_tag?(tag)
    tag.class.name == 'Integer'
  end

  def tag_exists?(kata_id, avatar_name, tag)
    # Has to work with old git-format and new non-git format
    0 <= tag && tag <= read_avatar_increments(kata_id, avatar_name).size
  end

  def tag_dir(kata_id, avatar_name, tag)
    disk[tag_path(kata_id, avatar_name, tag)]
  end

  def tag_path(kata_id, avatar_name, tag)
    dir_join(avatar_path(kata_id, avatar_name), tag.to_s)
  end

  # - - - - - - - - - - -

  def dir_join(*args)
    File.join(*args)
  end

  def invalid(message)
    ArgumentError.new("invalid #{message}")
  end

  # - - - - - - - - - - -

  include AllAvatarsNames

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo its initial
# "tag-zero" is *not* recorded in its increments.json
# file which starts as [ ]
# It probably should be but isn't for existing dojos
# (created in the old git format) and so for backwards
# compatibility it stays that way.
#
# Every test event stores an entry in the increments.json
# file. eg
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
# However, it's conceivable I may create finer grained
# tags than just [test] events, eg
#    o) creating a new file
#    o) renaming a file
#    o) deleting a file
#    o) opening a different file
#    o) editing a file
#
# If this happens the difference between tags and lights
# will be more pronounced.
# ------------------------------------------------------
