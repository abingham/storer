require_relative './storer_test_base'
require_relative './spy_logger'

class HostDiskStorerTest < StorerTestBase

  def self.hex_prefix; 'E4FDA20'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # parent
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '72D',
  "Storer's parent object is the test object" do
    assert_equal self, storer.parent
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # path
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '218',
  'path is set to /tmp in docker-compose.yml' do
    assert_equal '/tmp', storer.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_exists?(id)
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D0A',
  'kata_exists?(id) for id that is not a string is false' do
    not_string = Object.new
    refute storer.kata_exists?(not_string)
  end

  test '55F',
  'kata_exists?(id) for string not 10 chars long is false' do
    invalid = '60408161A'
    assert_equal 9, invalid.length
    refute storer.kata_exists?(invalid)
  end

  test '8F9',
  'kata_exists?(id) for string 10 chars long but not all hex is false' do
    invalid = '60408161AG'
    assert_equal 10, invalid.length
    refute storer.kata_exists?(invalid)
  end

  test '79A',
  'kata_exists?(good-id) false' do
    refute storer.kata_exists?(kata_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # create_kata
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B99',
  'after create_kata(manifest) kata_exists?(id) is true and manifest can be retrieved' do
    manifest = create_kata
    assert storer.kata_exists?(kata_id)
    assert_hash_equal manifest, kata_manifest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # completed
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B65',
  'completed(id=nil) is empty string' do
    assert_equal '', storer.completed(nil)
  end

  test 'D39',
  'completed(id="") is empty string' do
    assert_equal '', storer.completed('')
  end

  test '42E',
  'completed(id) does not complete when id is less than 6 chars in length',
  'because trying to complete from a short id will waste time going through',
  'lots of candidates (on disk) with the likely outcome of no unique result' do
    id = kata_id[0..4]
    assert_equal 5, id.length
    assert_equal id, storer.completed(id)
  end

  test '071',
  'completed(id) unchanged when no matches' do
    id = kata_id
    (0..7).each { |size| assert_equal id[0..size], storer.completed(id[0..size]) }
  end

  test '23B',
  'completed(id) does not complete when 6+ chars and more than one match' do
    uncompleted_id = kata_id[0..5]
    create_kata(uncompleted_id + '234' + '5')
    create_kata(uncompleted_id + '234' + '6')
    assert_equal uncompleted_id, storer.completed(uncompleted_id)
  end

  test '093',
  'completed(id) completes when 6+ chars and 1 match' do
    completed_id = kata_id
    create_kata(completed_id)
    uncompleted_id = completed_id.downcase[0..5]
    assert_equal completed_id, storer.completed(uncompleted_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ids_for
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '35C',
  'ids_for(outer) zero matches' do
    assert_equal [], storer.ids_for('C5')
  end

  test '0D6',
  'ids_for(outer) returns inner-dirs, one match' do
    kata_id = '0D6E4FDA26'
    create_kata(kata_id)
    assert_equal [inner(kata_id)], storer.ids_for('0D')
  end

  test 'A03',
  'ids_for(outer) returns inner-dirs, two close matches' do
    kata_ids = [ 'A03E4FDA20', 'A03E4FDA21' ]
    kata_ids.each { |id| create_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.ids_for('A0').sort
  end

  test '7FC',
  'ids_for(outer) returns inner-dirs, three far matches' do
    kata_ids = [ '7FC2034534', '7FD92F11B0', '7F13E86582' ]
    kata_ids.each { |id| create_kata(id) }
    expected = kata_ids.collect { |id| inner(id) }
    assert_equal expected.sort, storer.ids_for('7F').sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # start_avatar
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6B',
  'avatar_exists? is false before avatar starts' do
    create_kata
    refute storer.avatar_exists?(kata_id, lion)
    assert_equal [], storer.kata_started_avatars(kata_id)
  end

  test 'F6E',
  'rogue sub-dirs in kata-dir are not reported as avatars' do
    create_kata
    rogue = 'flintstone'
    disk[kata_path + '/' + rogue].make
    assert_equal [rogue], disk[kata_path].each_dir.collect { |name| name }
    assert_equal [], storer.kata_started_avatars(kata_id)
  end

  test 'CBF',
  'avatar_start(not-an-avatar-name) fails' do
    create_kata
    assert_nil storer.kata_start_avatar(kata_id, ['pencil'])
  end

  test 'E0C',
  'avatar_exists? is true after avatar_starts;',
  'avatar has no traffic-lights;',
  "avatar's visible_files are from the kata"  do
    create_kata
    storer.kata_start_avatar(kata_id, [lion])
    assert storer.avatar_exists?(kata_id, lion)
    assert_equal [lion], storer.kata_started_avatars(kata_id)
    assert_equal [], avatar_increments(lion)
    assert_hash_equal starting_files, avatar_visible_files(lion)
    assert_hash_equal starting_files, tag_visible_files(lion, tag=0)
  end

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    create_kata
    all_avatar_names.each { |name| disk[avatar_path(name)].make }
    assert_equal all_avatar_names.sort, storer.kata_started_avatars(kata_id).sort
    assert_nil storer.kata_start_avatar(kata_id, all_avatar_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF',
  'after ran_tests() there is one more tag, one more traffic-light;',
  'visible_files are retrievable by current and specific git-tag and contain output' do
    create_kata
    storer.kata_start_avatar(kata_id, [lion]) # tag 0
    args = []
    args << kata_id
    args << lion
    args << delta = { unchanged:[starting_files.keys], changed:[], deleted:[], new:[] }
    args << starting_files
    args << time_now
    args << output = 'Assertion failed: answer() == 42'
    args << colour = 'red'
    storer.avatar_ran_tests(*args)
    tag = 1
    # traffic-lights
    expected = [ {'colour'=>colour, 'time'=>time_now, 'number'=>tag} ]
    assert_equal expected, avatar_increments(lion)
    # current tag
    visible_files = avatar_visible_files(lion)
    assert_equal output, visible_files['output'], 'output'
    starting_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
    # by tag
    visible_files = tag_visible_files(lion, tag)
    assert_equal output, visible_files['output'], 'output'
    starting_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # git commits
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1FB',
  'traffic-lights are git versioned to maintain compatibility with download tgz format' do
    create_kata
    storer.kata_start_avatar(kata_id, [lion])
    tag = 0
    filename = 'increments.json'
    assert_equal '[]', git.show(avatar_path(lion), "#{tag}:#{filename}")
  end

  test '78B',
  'output file is NOT git versioned' do
    @log = SpyLogger.new(nil)
    create_kata
    storer.kata_start_avatar(kata_id, [lion]) # tag 0

    delta = { changed:[], deleted:[], new:[] }
    delta[:unchanged] = [starting_files.keys]
    storer.avatar_ran_tests(*make_args(delta, starting_files))

    tag = 1
    filename = 'sandbox/output'
    git.show(avatar_path(lion), "#{tag}:#{filename}")
    assert log.spied.include? "STDERR:fatal: Path 'sandbox/output' does not exist in '1'\n"
  end

  test '04A',
  'changed files are git commited to the tag' do
    create_kata
    storer.kata_start_avatar(kata_id, [lion]) # tag 0

    hiker_c = starting_files['hiker.c'] + "\nint main(){}"
    files = starting_files
    files['hiker.c'] = hiker_c
    delta = { deleted:[], new:[] }
    delta[:unchanged] = [starting_files.keys]-['hiker.c']
    delta[:changed] = ['hiker.c']
    storer.avatar_ran_tests(*make_args(delta, files))

    tag = 1
    files.each do |filename,content|
      assert_equal content, git.show(avatar_path(lion), "#{tag}:sandbox/#{filename}")
    end
  end

  test 'BE5',
  'deleted files are git removed from the tag' do
    @log = SpyLogger.new(nil)
    create_kata
    storer.kata_start_avatar(kata_id, [lion]) # tag 0

    files = starting_files
    files.delete('hiker.h')
    delta = { changed:[], new:[] }
    delta[:unchanged] = [starting_files.keys]-['hiker.h']
    delta[:deleted] = ['hiker.h']
    storer.avatar_ran_tests(*make_args(delta, files))

    tag = 1
    filename = 'sandbox/hiker.h'
    git.show(avatar_path(lion), "#{tag}:#{filename}")
    assert log.spied.include? "STDERR:fatal: Path 'sandbox/hiker.h' does not exist in '1'\n"
  end

  test '08F',
  'new files are git added to the tag' do
    create_kata
    storer.kata_start_avatar(kata_id, [lion]) # tag 0

    files = starting_files
    delta = { changed:[], deleted:[] }
    delta[:unchanged] = [files.keys]
    files['readme.txt'] = 'NB:'
    delta[:new] = ['readme.txt']
    storer.avatar_ran_tests(*make_args(delta, files))

    tag = 1
    filename = 'sandbox/readme.txt'
    assert_equal 'NB:', git.show(avatar_path(lion), "#{tag}:#{filename}")
  end

  private

  def kata_manifest
    JSON.parse(storer.kata_manifest(kata_id))
  end

  def avatar_increments(name)
    JSON.parse(storer.avatar_increments(kata_id, name))
  end

  def avatar_visible_files(name)
    JSON.parse(storer.avatar_visible_files(kata_id, name))
  end

  def tag_visible_files(name, tag)
    JSON.parse(storer.tag_visible_files(kata_id, name, tag))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_id
    test_id.reverse # reversed so I don't get common outer(id)s
  end

  def lion
    'lion'
  end

  def time_now
    [2016, 12, 2, 6, 14, 57]
  end

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

  def create_kata(id = kata_id)
    manifest = {}
    manifest[:image_name] = 'cyberdojofoundation/python_behave'
    manifest[:visible_files] = starting_files
    manifest[:id] = id
    storer.create_kata(manifest)
    manifest
  end

  def starting_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c' => '#include "hiker.h"',
      'hiker.h' => '#include <stdio.h>'
    }
  end

  def make_args(delta, files)
    args = []
    args << kata_id
    args << lion
    args << delta
    args << files
    args << time_now
    args << output = 'Assertion failed: answer() == 42'
    args << colour = 'red'
    args
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_path
    storer.path + '/' + outer(kata_id) + '/' + inner(kata_id)
  end

  def avatar_path(name)
    kata_path + '/' + name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def outer(id)
    id[0..1]
  end

  def inner(id)
    id[2..-1]
  end

  def assert_hash_equal(expected, actual)
    assert_equal expected.size, actual.size
    expected.each do |symbol,value|
      assert_equal value, actual[symbol.to_s], symbol.to_s
    end
  end

end
