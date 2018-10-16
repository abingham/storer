require_relative 'test_base'
require 'json'

class StorerKataManifestTest < TestBase

  def self.hex_prefix
    '33DD9'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '456',
  'failing test case from when Seb upgraded the cucumber server' do
    kata_id = stubbed('1F00C1BFC8')
    raw = raw_manifest(kata_id)
    assert_equal 'Shouty, Ruby', raw['display_name']
    updated = storer.kata_manifest(kata_id)
    assert_unchanged(raw, updated, %w(
      id created
      display_name image_name runner_choice visible_files
      filename_extension highlight_filenames progress_regexs tab_size
    ))
    assert_dropped(raw, updated, 'language')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2A',
  'new-style kata not involving renaming (dolphin, 20 lights)' do
    kata_id = stubbed('420B05BA0A')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated, %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames progress_regexs tab_size
    ))
    assert_dropped(raw, updated, 'language')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2B',
  'new-style kata not involving renaming (snake, 0 lights)' do
    kata_id = stubbed('420F2A2979')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated, %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames progress_regexs tab_size
    ))
    assert_dropped(raw, updated, 'language')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2C',
  'old-style kata involving renaming (buffalo, 36 lights)' do
    kata_id = stubbed('421F303E80')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated,
      %w( id created tab_size visible_files exercise )
    )
    assert_dropped(raw, updated,
      %w( language unit_test_framework browser )
    )
    assert_added(raw, updated, {
      'display_name' => 'C (gcc), assert',
      'image_name' => 'cyberdojofoundation/gcc_assert',
      'runner_choice' => 'stateless',
      'filename_extension' => '.c'
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2D',
  'old-style kata involving renaming (wolf, 1 light)' do
    kata_id = stubbed('421AFD7EC5')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated,
      %w( id created tab_size visible_files exercise )
    )
    assert_dropped(raw, updated,
      %w( language unit_test_framework )
    )
    assert_added(raw, updated, {
      'display_name' => 'Ruby, RSpec',
      'image_name' => 'cyberdojofoundation/ruby_rspec',
      'runner_choice' => 'stateless',
      'filename_extension' => '.rb'
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2E',
  'old-style kata not involving renaming (hummingbird, 0 lights)' do
    kata_id = stubbed('420BD5D5BE')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated,
      %w( id created tab_size visible_files exercise )
    )
    assert_dropped(raw, updated,
      %w( language unit_test_framework )
    )
    assert_added(raw, updated, {
      'display_name' => 'Python, py.test',
      'image_name' => 'cyberdojofoundation/python_pytest',
      'runner_choice' => 'stateless',
      'filename_extension' => '.py'
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2F',
  'new-style kata not involving renaming (spider, 8 lights) with red_amber_green property' do
    kata_id = stubbed('5A0F824303')
    raw = raw_manifest(kata_id)
    updated = storer.kata_manifest(kata_id)

    assert_unchanged(raw, updated,
      %w( id created display_name exercise image_name visible_files
          filename_extension highlight_filenames
          progress_regexs tab_size )
    )
    assert_dropped(raw, updated,
      %w( language red_amber_green )
    )
    assert_added(raw, updated, {
      'runner_choice' => 'stateless',
    })
  end

  private # = = = = = = = = = = = = = = =

  def assert_unchanged(raw, updated, properties)
    properties = [properties] unless properties.is_a?(Array)
    properties.each do |property|
      refute_nil raw[property], property
      refute_nil updated[property], property
      assert_equal raw[property], updated[property]
    end
  end

  def assert_dropped(raw, updated, properties)
    properties = [properties] unless properties.is_a?(Array)
    properties.each do |property|
      refute_nil raw[property]
      assert_nil updated[property]
    end
  end

  def assert_added(raw, updated, properties)
    properties.keys.each do |property|
      assert_nil raw[property]
      refute_nil updated[property]
      assert_equal properties[property], updated[property]
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def stubbed(kata_id)
    external.id_generator = IdGeneratorStub.new
    id_generator.stub(kata_id)
    # DONT call storer.kata_create()
    # The test rig is volume-mounting known katas
    kata_id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def raw_manifest(kata_id)
    outer = kata_id[0..1]
    inner = kata_id[2..-1]
    dir = [cyber_dojo_katas_root,outer,inner].join('/')
    JSON.parse(IO.read(dir + '/manifest.json'))
  end

end
