require_relative './nearest_external'
require 'json'

class HostDiskStorer

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def path
    @path ||= ENV['CYBER_DOJO_KATAS_ROOT']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # katas
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def completed(id)
    # Used only in enter_controller/check
    # If at least 6 characters of the id are provided attempt to complete
    # it into the full 10 character id. Doing completion with fewer characters
    # would likely result in a lot of disk activity and no unique outcome.
    # Also, if completion was attempted for a very short id (say 3 characters)
    # it would provide a way for anyone to find the full id of a cyber-dojo
    # and potentially interfere with a live session.
    if !id.nil? && id.length >= 6
      outer_dir = disk[path + '/' + outer(id)]
      if outer_dir.exists?
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(inner(id)) }
        id = outer(id) + dirs[0] if dirs.length == 1
      end
    end
    id || ''
  end

  def ids_for(outer_dir)
    # for Batch-Method iteration over large number of katas...
    return [] unless disk[path + '/' + outer_dir].exists?
    disk[path + '/' + outer_dir].each_dir.collect { |dir| dir }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_exists?(id)
    valid?(id) && kata_dir(id).exists?
  end

  def create_kata(manifest)
    # a kata's id has 10 hex chars. This gives 16^10 possibilities
    # which is 1,099,511,627,776 which is big enough to not
    # need to check that a kata with the id already exists.
    dir = kata_dir(manifest[:id])
    dir.make
    dir.write(manifest_filename, JSON.unparse(manifest))
  end

  def kata_manifest(id)
    JSON.parse(kata_dir(id).read(manifest_filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_exists?(id, name)
    avatar_dir(id, name).exists?
  end

  def kata_started_avatars(id)
    started = kata_dir(id).each_dir.collect { |name| name }
    started & all_avatar_names
  end

  def kata_start_avatar(id, avatar_names)
    # Needs to be atomic otherwise two laptops in the same practice session
    # could start as the same animal. This relies on mkdir being atomic on
    # a (non NFS) POSIX file system.
    # Note: Don't do the & with operands swapped - you lose randomness
    valid_names = avatar_names & all_avatar_names
    name = valid_names.detect { |name| avatar_dir(id, name).make }
    return nil if name.nil? # full!

    user_name = name + '_' + id
    user_email = name + '@cyber-dojo.org'
    git.setup(avatar_path(id, name), user_name, user_email)

    visible_files = kata_manifest(id)['visible_files']

    write_avatar_manifest(id, name, visible_files)
    git.add(avatar_path(id, name), manifest_filename)

    write_avatar_increments(id, name, [])
    #git.add(avatar_path(id, name), increments_filename)

    git.commit(avatar_path(id, name), tag=0)

    name
  end

  def avatar_increments(id, name)
    # for current (latest) tag
    JSON.parse(avatar_dir(id, name).read(increments_filename))
  end

  def avatar_visible_files(id, name)
    # for current (latest) tag
    JSON.parse(avatar_dir(id, name).read(manifest_filename))
  end

  #def avatar_ran_tests(id, name, delta, files, now, output, colour)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def tag_visible_files(id, name, tag)
    # retrieve all the files in one go
    JSON.parse(git.show(avatar_path(id, name), "#{tag}:#{manifest_filename}"))
  end

  private

  def all_avatar_names
    %w(alligator antelope   bat     bear     bee      beetle       buffalo   butterfly
       cheetah   crab       deer    dolphin  eagle    elephant     flamingo  fox
       frog      gopher     gorilla heron    hippo    hummingbird  hyena     jellyfish
       kangaroo  kingfisher koala   leopard  lion     lizard       lobster   moose
       mouse     ostrich    owl     panda    parrot   peacock      penguin   porcupine
       puffin    rabbit     raccoon ray      rhino    salmon       seal      shark
       skunk     snake      spider  squid    squirrel starfish     swan      tiger
       toucan    tuna       turtle  vulture  walrus   whale        wolf      zebra
    )
  end

  # - - - - - - - - - - -

  def kata_dir(id)
    disk[kata_path(id)]
  end

  def avatar_dir(id, name)
    disk[avatar_path(id, name)]
  end

  # - - - - - - - - - - -

  def kata_path(id)
    path + '/' + outer(id) + '/' + inner(id)
  end

  def avatar_path(id, name)
    kata_path(id) + '/' + name
  end

  # - - - - - - - - - - -

  def outer(id)
    id.upcase[0..1]  # eg 'E5' 2-chars long
  end

  def inner(id)
    inner = id.upcase[2..-1] # eg '6A3327FE' 8-chars long
  end

  # - - - - - - - - - - -

  def valid?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

  # - - - - - - - - - - -

  def manifest_filename
    # Each kata's manifest stores the kata's meta information
    # such as the chosen language, tests, exercise.
    # Each avatar's manifest stores a cache of the avatar's
    # current visible files [filenames and contents].
    'manifest.json'
  end

  def write_avatar_manifest(id, name, visible_files)
    avatar_dir(id, name).write(manifest_filename, JSON.unparse(visible_files))
  end

  # - - - - - - - - - - -

  def increments_filename
    # Each avatar's increments stores a cache of colours and time-stamps
    # for all the avatar's [test]s. Helps optimize traffic-lights views.
    'increments.json'
  end

  def write_avatar_increments(id, name, increments)
    avatar_dir(id, name).write(increments_filename, JSON.unparse(increments))
  end

  # - - - - - - - - - - -

  def disk; nearest_external(:disk); end
  def git; nearest_external(:git); end

  include NearestExternal

end
