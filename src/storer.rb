require_relative 'all_avatars_names'
require_relative 'updater'
require 'json'

class Storer

  def initialize(external)
    @path = '/usr/src/cyber-dojo/katas'
    @disk = external.disk
    @shell = external.shell
    @kata_id_generator = external.kata_id_generator
  end

  attr_reader :path

  def sha
    IO.read('/app/sha.txt').strip
  end

  # - - - - - - - - - - - - - - - - - - -
  # completion(s)
  # - - - - - - - - - - - - - - - - - - -

  def katas_completed(partial_id)
    # A partial_id has at least 6 characters. Doing
    # completion with fewer characters would likely result in
    # a lot of disk activity and no unique outcome.
    outer_dir = disk[dir_join(path, outer(partial_id))]
    unless outer_dir.exists?
      return []
    end
    # As the number of inner dirs increases this
    # will get sloooooow...
    dirs = outer_dir.each_dir.select { |inner_dir|
      inner_dir.start_with?(inner(partial_id))
    }
    dirs.map {|inner_dir| outer(partial_id) + inner_dir }
  end

  # - - - - - - - - - - - - - - - - - - -

  def katas_completions(outer_id)
    # for Batch-Method iteration over large number of katas...
    unless disk[dir_join(path, outer_id)].exists?
      return []
    end
    disk[dir_join(path, outer_id)].each_dir.collect { |dir| dir }
  end

  # - - - - - - - - - - - - - - - - - - -
  # kata
  # - - - - - - - - - - - - - - - - - - -

  def kata_exists?(kata_id)
    kata_dir(kata_id).exists?
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_create(manifest)
    # Generates a kata-id, puts it in the manifest,
    # saves the manifest, and returns the kata-id.
    # Rack calls kata_create() in threads so in
    # theory you could get a race condition with
    # both threads attempting to create a
    # kata with the same id.
    # Assuming base58 id generation is reasonably well
    # behaved (random) this is extremely unlikely.
    kata_id = kata_id_generator.generate
    manifest['id'] = kata_id
    dir = kata_dir(kata_id)
    dir.make
    dir.write(manifest_filename, JSON.unparse(manifest))
    kata_id
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_delete(kata_id)
    assert_kata_exists(kata_id)
    dir = kata_dir(kata_id)
    dir.rm
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_manifest(kata_id)
    assert_kata_exists(kata_id)
    dir = kata_dir(kata_id)
    json = dir.read(manifest_filename)
    Updater.updated(JSON.parse!(json))
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_increments(kata_id)
    Hash[avatars_started(kata_id).map { |name|
      [name, avatar_increments(kata_id, name)]
    }]
  end

  # - - - - - - - - - - - - - - - - - - -
  # avatar
  # - - - - - - - - - - - - - - - - - - -

  def avatar_exists?(kata_id, avatar_name)
    avatar_dir(kata_id, avatar_name).exists?
  end

  # - - - - - - - - - - - - - - - - - - -

  def avatar_start(kata_id, avatar_names)
    # storer.avatar_start() relies on mkdir being
    # atomic on a (non NFS) POSIX file system.
    # Otherwise two laptops in the same practice session
    # could start as the same animal.
    assert_kata_exists(kata_id)
    avatar_name = avatar_names.detect { |name|
      avatar_dir(kata_id, name).make
    }
    if avatar_name.nil? # full!
      return nil
    end
    write_avatar_increments(kata_id, avatar_name, [])
    avatar_name
  end

  # - - - - - - - - - - - - - - - - - - -

  def avatars_started(kata_id)
    assert_kata_exists(kata_id)
    started = kata_dir(kata_id).each_dir.collect { |name| name }
    started & all_avatars_names
  end

  # - - - - - - - - - - - - - - - - - - -

  def avatar_ran_tests(kata_id, avatar_name, files, now, stdout, stderr, colour)
    assert_avatar_exists(kata_id, avatar_name)
    increments = read_avatar_increments(kata_id, avatar_name)
    tag = most_recent_tag(kata_id, avatar_name, increments) + 1
    increments << { 'colour' => colour, 'time' => now, 'number' => tag }
    write_avatar_increments(kata_id, avatar_name, increments)
    # don't alter caller's files argument
    files = files.clone
    files['output'] = stdout + stderr
    write_tag_files(kata_id, avatar_name, tag, files)
    increments
  end

  # - - - - - - - - - - - - - - - - - - -

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

  # - - - - - - - - - - - - - - - - - - -

  def avatar_visible_files(kata_id, avatar_name)
    assert_avatar_exists(kata_id, avatar_name)
    tag = most_recent_tag(kata_id, avatar_name)
    tag_visible_files(kata_id, avatar_name, tag)
  end

  # - - - - - - - - - - - - - - - - - - -
  # tag
  # - - - - - - - - - - - - - - - - - - -

  def tag_fork(kata_id, avatar_name, tag, now)
    visible_files = tag_visible_files(kata_id, avatar_name, tag)
    manifest = kata_manifest(kata_id)
    manifest['visible_files'] = visible_files
    manifest['created'] = now
    forked_id = kata_create(manifest)
    forked_id
  end

  # - - - - - - - - - - - - - - - - - - -

  def tag_visible_files(kata_id, avatar_name, tag)
    assert_avatar_exists(kata_id, avatar_name)
    if tag == -1
      tag = most_recent_tag(kata_id, avatar_name)
    end
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
      JSON.parse!(src)
    end
  end

  # - - - - - - - - - - - - - - - - - - -
  # tags
  # - - - - - - - - - - - - - - - - - - -

  def tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
    {
      'was_tag' => tag_visible_files(kata_id, avatar_name, was_tag),
      'now_tag' => tag_visible_files(kata_id, avatar_name, now_tag)
    }
  end

  private # = = = = = = = = = = = = = = =

  attr_reader :disk, :shell, :kata_id_generator

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
    JSON.parse!(json)
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
    JSON.parse!(json)
  end

  def manifest_filename
    # A kata's manifest stores the kata's meta information
    # such as the chosen language, chosen tests framework,
    # chosen exercise.
    # An avatar's manifest stores avatar's visible-files.
    'manifest.json'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # kata
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_kata_exists(kata_id)
    unless kata_exists?(kata_id)
      invalid('kata_id')
    end
  end

  def kata_dir(kata_id)
    disk[kata_path(kata_id)]
  end

  def kata_path(kata_id)
    dir_join(path, outer(kata_id), inner(kata_id))
  end

  def outer(kata_id)
    kata_id[0..1]  # eg 'e5' 2-chars long
  end

  def inner(kata_id)
    kata_id[2..-1] # eg '6aM327PE' 8-chars long
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_avatar_exists(kata_id, avatar_name)
    unless avatar_exists?(kata_id, avatar_name)
      invalid('avatar_name')
    end
  end

  def avatar_dir(kata_id, avatar_name)
    disk[avatar_path(kata_id, avatar_name)]
  end

  def avatar_path(kata_id, avatar_name)
    dir_join(kata_path(kata_id), avatar_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # tag
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_tag_exists(kata_id, avatar_name, tag)
    unless tag_exists?(kata_id, avatar_name, tag)
      invalid('tag')
    end
  end

  def tag_exists?(kata_id, avatar_name, tag)
    # Has to work with old git-format and new non-git format
    0 <= tag && tag <= most_recent_tag(kata_id, avatar_name)
  end

  def tag_dir(kata_id, avatar_name, tag)
    disk[tag_path(kata_id, avatar_name, tag)]
  end

  def tag_path(kata_id, avatar_name, tag)
    dir_join(avatar_path(kata_id, avatar_name), tag.to_s)
  end

  # - - - - - - - - - - -

  def most_recent_tag(kata_id, avatar_name, increments = nil)
    increments ||= read_avatar_increments(kata_id, avatar_name)
    increments.size
  end

  # - - - - - - - - - - -

  def dir_join(*args)
    File.join(*args)
  end

  def invalid(name)
    fail ArgumentError.new("#{name}:invalid")
  end

  # - - - - - - - - - - -

  include AllAvatarsNames

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo its initial
# "tag-zero" is *not* recorded in its increments.json
# file which starts as []
# Maybe it should be but it isn't for existing dojos
# (created in the old git format) and so for backwards
# compatibility it stays that way.
#
# Every test event stores a tag entry in the increments.json
# file. eg
# [
#   ...
#   {
#     'colour' => 'red',
#     'time'   => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   }
# ]
#
# At the moment the only event that creates an
# increments.json file entry is a [test].
#
# However, it's conceivable I may create finer grained
# tags than just [test] events, eg
#    o) "file new/rename/delete"
#    o) "file open/edit"
#
# If this happens the difference between tags and lights
# will be more pronounced. Viz, lights will become a proper
# subset of tags. For example, increments.json could be
#
# [
#   ...
#   { 'event'  => 'file new',
#     'time'   => [2014, 2, 15, 8, 54, 6],
#     'number' => 23
#   },
#   {
#     'colour' => 'red',
#     'time'   => [2014, 2, 15, 8, 54, 6],
#     'number' => 24
#   }
# ]
# ------------------------------------------------------
