require_relative 'test_base'

class StorerTest < TestBase

  def self.hex_prefix
    'E4FDA'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # path
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '218',
  'katas_root is set to same as prod but there is no volume-mount so its emphemeral' do
    assert_equal cyber_dojo_katas_root, storer.path
    assert_equal '/usr/src/cyber-dojo/katas', storer.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_exists?
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '42E',
  'kata_exists false' do
    refute kata_exists?('123456789A')
  end

  test '42F',
  'kata_exists true' do
    kata_id = storer.kata_create(create_manifest)
    assert kata_exists?(kata_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_manifest
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B98',
  'kata_manifest() on invalid kata_id raises' do
    error = assert_raises { kata_manifest('1234567890') }
    assert_equal 'kata_id:invalid', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_create
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B99',
  'after kata_create(manifest) manifest has id/created properties' do
    expected = %w(
      created
      display_name
      exercise
      filename_extension
      image_name
      visible_files
    )
    manifest = create_manifest
    assert_equal expected.sort, manifest.keys.sort

    id = storer.kata_create(manifest)
    manifest = kata_manifest(id)
    expected << 'id'
    expected << 'runner_choice'
    assert_equal expected.sort, manifest.keys.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_delete
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D64',
  'kata_delete removes a previously created kata' do
    manifest = create_manifest
    id = storer.kata_create(manifest)
    assert storer.kata_exists?(id)
    storer.kata_delete(id)
    refute storer.kata_exists?(id)
  end

  test 'D65', %w(
  kata_delete(id) cannot fully delete a kata when it is owned by the nobody
  user instead of the storer user (as some are), but katas_completions()
  and kata_exists? must nevertheless exclude ids of deleted katas from what
  it returns - the porter service relies on this
  ) do
    kata_ids = %w(
      890C8AE514
      89716C1BC6
    )
    kata_ids.each do |kata_id|
      stdout = with_captured_stdout { storer.kata_delete(kata_id) }
      denied = "Permission denied\\nrm: can't remove"
      diagnostic = ":#{kata_id}:#{stdout}:"
      assert stdout.include?(denied), diagnostic
      refute storer.kata_exists?(kata_id), "!storer.kata_exists?(#{kata_id})"
      all89 = storer.katas_completions('89')
      diagnostic = "storer.katas_completions('89') still includes #{kata_id[2..-1]}"
      refute all89.include?(kata_id[2..-1]), diagnostic
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # kata_increments
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '822',
  'kata_increments raises when kata_id is invalid' do
    error = assert_raises { kata_increments('1234567890') }
    assert_equal 'kata_id:invalid', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_start, avatars_started, avatar_exists?
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A6B',
  'before starting an avatar it does not exist, afterwards it does' do
    id = make_kata
    assert_equal([], avatars_started(id))
    assert_equal({}, kata_increments(id))
    refute avatar_exists?(id, lion)
    assert_equal lion, avatar_start(id, [lion])
    assert avatar_exists?(id, lion)
  end

  test '823',
  'avatar_start raises when kata_id is invalid' do
    error = assert_raises { avatar_start('1234567890', lion) }
    assert_equal 'kata_id:invalid', error.message
  end

  test '824',
  'avatars_started raises when kata_id is invalid' do
    error = assert_raises { avatars_started('1234567890') }
    assert_equal 'kata_id:invalid', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F6E',
  'rogue sub-dirs in kata-dir are not reported as avatars' do
    id = make_kata
    rogue = 'flintstone'
    disk[kata_path(id) + '/' + rogue].make
    assert_equal [rogue], disk[kata_path(id)].each_dir.collect { |name| name }
    assert_equal [], avatars_started(id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F6F', %w(
  some avatars have somehow got no increments.json file
  and these must not be listed in avatars_started
  ) do
    # these kata-ids are in the inserter data set called 'red'
    %w( 020123D57E 0237439B3C ).each do |kata_id|
      assert kata_exists?(kata_id), "#{kata_id} does not exist!"
      assert_equal [], avatars_started(kata_id)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F6D', %w(
  storer did protect against large files, euch,
  retrieving from large files must not cause out-of-memory exception
  as this will cause the oom-killer to kill the service
  ) do
    kata_id = 'FD3D55C9E3'
    assert kata_exists?(kata_id), "#{kata_id} does not exist!"
    assert avatar_exists?(kata_id, 'zebra')
    incs = avatar_increments(kata_id, 'zebra')
    incs.each do |inc|
      index = inc['number']
      files = tag_visible_files(kata_id, 'zebra', index)
      files.each do |filename,content|
        assert content.size < (50*1024), "#{index}:#{filename}:#{content.size}:"
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E0C', %w(
    after avatar_starts:
    avatar has no traffic-lights,
    avatar's visible_files are from the kata,
    avatar's increments already have tag zero
  ) do
    id = make_kata
    assert_equal lion, avatar_start(id, [lion])
    assert_equal [lion], avatars_started(id)
    expected_filenames = %w(
      cyber-dojo.sh
      hiker.h
      hiker.c
      hiker.tests.c
      instructions
      makefile
    ).sort
    assert_equal expected_filenames, avatar_visible_files(id, lion).keys.sort
    assert_equal expected_filenames, tag_visible_files(id, lion, tag=0).keys.sort
    tag0 =
    {
      'event'  => 'created',
      'time'   => creation_time,
      'number' => 0
    }
    assert_equal [tag0], avatar_increments(id, lion)
    assert_equal( { lion => [tag0] }, kata_increments(id))

    assert_equal tiger, avatar_start(id, [tiger])
    assert_equal [lion,tiger].sort, avatars_started(id).sort
    assert_equal [tag0], avatar_increments(id, tiger)
    assert_equal( { lion => [tag0], tiger => [tag0] }, kata_increments(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B1C',
  'avatar_start succeeds 64 times then kata is full' do
    id = make_kata
    all_avatars_names.size.times do
      avatar_start(id, all_avatars_names)
    end
    assert_equal all_avatars_names.sort, avatars_started(id).sort
    assert_nil avatar_start(id, all_avatars_names)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_increments
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CD',
  'avatar_increments:kata_id that does not exist raises' do
    error = assert_raises {
      avatar_increments('123456789A', 'salmon')
    }
    assert error.message.include? 'invalid'
  end

  test '3CE',
  'avatar_increments:avatar_name that does not exist raises' do
    id = make_kata
    error = assert_raises {
      avatar_increments(id, 'salmon')
    }
    assert error.message.include? 'invalid'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # avatar_ran_tests
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3CF', %w(
    after ran_tests():
    there is one more tag,
    one more traffic-light,
    visible_files are retrievable by implicit current-tag,
    visible_files are retrievable by explicit tag
  ) do
    kata_id = make_kata(starting_files)
    avatar_start(kata_id, [lion])
    was_tag = 0

    avatar_ran_tests(*make_args(kata_id, edited_files))
    now_tag = 1

    # traffic-lights
    expected = [
      { 'event'  => 'created',
        'time'   => creation_time,
        'number' => was_tag
      },
      { 'colour' => red,
        'time'   => time_now,
        'number' => now_tag
      }
    ]
    assert_equal expected, avatar_increments(kata_id, lion)
    assert_equal({ lion => expected }, kata_increments(kata_id))
    # current tag
    visible_files = avatar_visible_files(kata_id, lion)
    assert_equal stdout+stderr, visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, visible_files[filename], filename
    end
    # was_tag
    was_tag_visible_files = tag_visible_files(kata_id, lion, was_tag)
    refute was_tag_visible_files.keys.include?('output')
    starting_files.each do |filename,content|
      assert_equal content, was_tag_visible_files[filename], filename
    end
    # now_tag
    now_tag_visible_files = tag_visible_files(kata_id, lion, now_tag)
    assert_equal stdout+stderr, now_tag_visible_files['output'], 'output'
    edited_files.each do |filename,content|
      assert_equal content, now_tag_visible_files[filename], filename
    end
    # both tags at once
    hash = tags_visible_files(kata_id, lion, was_tag, now_tag)
    assert_hash_equal was_tag_visible_files, hash['was_tag']
    assert_hash_equal now_tag_visible_files, hash['now_tag']
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag_fork
  # test-data: 420B05BA0A, dolphin, 20 rags
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '818',
  %w( tag_fork with valid arguments ) do
    id = '420B05BA0A'
    tag = 20
    now = [2018,3,16, 9,57,19]
    forked_id = tag_fork(id, 'dolphin', tag, now)
    refute_equal forked_id, id

    manifest = kata_manifest(id)
    forked_manifest = kata_manifest(forked_id)
    assert_equal manifest.keys.sort, forked_manifest.keys.sort
    manifest.keys.each do |key|
      case key
        when 'id'
          assert_equal id, manifest['id']
          assert_equal forked_id, forked_manifest['id']
        when 'created'
          refute_equal manifest['created'], forked_manifest['created']
          assert_equal now, forked_manifest['created']
        when 'visible_files'
          refute_equal manifest['visible_files'], forked_manifest['visible_files']
          assert_equal tag_visible_files(id, 'dolphin', tag), forked_manifest['visible_files']
        else
          assert_equal manifest[key], forked_manifest[key]
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # tag_visible_files
  # test-data: 420B05BA0A, dolphin, 20 rags
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '170',
  %w( tag_visible_files with valid +ve tag ) do
    visible_files = tag_visible_files('420B05BA0A', 'dolphin', 20)
    expected = %w(
      Calcolatrice.java
      HikerTest.java
      cyber-dojo.sh
      instructions
      output
    )
    assert_equal expected.sort, visible_files.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '171',
  %w( tag_visible_files with -1 tag is last tag ) do
    visible_files = tag_visible_files('420B05BA0A', 'dolphin', -1)
    expected = %w(
      Calcolatrice.java
      HikerTest.java
      cyber-dojo.sh
      instructions
      output
    )
    assert_equal expected.sort, visible_files.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '172',
  %w( tag_visible_files raises when tag is invalid ) do
    error = assert_raises(ArgumentError) {
      tag_visible_files('420B05BA0A', 'dolphin', 21)
    }
    assert_equal 'tag:invalid', error.message
  end

  private # = = = = = = = = = = = = = = = = = = = = = = =

  def lion
    'lion'
  end

  def tiger
    'tiger'
  end

  def edited_files
    { 'cyber-dojo.sh' => 'gcc',
      'hiker.c'       => '#include "hiker.h"',
      'hiker.h'       => '#ifndef HIKER_INCLUDED',
      'hiker.tests.c' => '#include <assert.h>'
    }
  end

  def make_args(id, files)
    [ id, lion, files, time_now, stdout, stderr, red ]
  end

  def time_now
    [2016,12,2, 6,14,57]
  end

  def stdout
    ''
  end

  def stderr
    'Assertion failed: answer() == 42'
  end

  def red
    'red'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_path(kata_id)
    path_join(storer.path, outer(kata_id), inner(kata_id))
  end

  def path_join(*args)
    File.join(*args)
  end

  def with_captured_stdout
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('', 'w')
      response = yield
      return $stdout.string
    ensure
      $stdout = old_stdout
    end
  end

end
