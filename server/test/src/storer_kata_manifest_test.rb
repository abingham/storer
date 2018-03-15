require_relative 'test_base'
require 'json'

class StorerKataManifestTest < TestBase

  def self.hex_prefix
    '33DD9'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '34A',
  'kata_manifest is raw manifest with no defaults applied' do
    assert_no_default 'tab_size'
    assert_no_default 'progress_regexs'
    assert_no_default 'lowlight_filenames'
    assert_no_default 'max_seconds'
    assert_no_default 'filename_extension'
    assert_no_default 'highlight_filenames'
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_no_default(name)
    manifest = create_manifest
    manifest.delete(name)
    kata_id = storer.create_kata(manifest)
    assert_nil storer.kata_manifest(kata_id)[name]
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'E2A',
  'new-style kata not involving renaming (dolphin, 20 lights)' do
    kata_id = stubbed('420B05BA0A')

    expected_raw_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal kata_id, raw['id']
    assert_equal [2017,10,25, 13,31,50], raw['created']
    assert_equal 'Java, JUnit', raw['display_name']
    assert_equal 'cyberdojofoundation/java_junit', raw['image_name']
    assert_equal 'stateless', raw['runner_choice']
    assert_equal '.java', raw['filename_extension']
    assert_equal 4, raw['tab_size']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
    )
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2017,10,25, 13,31,50]
    assert_display_name 'Java, JUnit'
    assert_exercise '(Verbal)'
    assert_image_name 'cyberdojofoundation/java_junit'
    assert_runner_choice 'stateless'
    assert_filename_extension '.java'
    assert_tab_size 4
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2B',
  'new-style kata not involving renaming (snake, 0 lights)' do
    kata_id = stubbed('420F2A2979')

    expected_raw_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal kata_id, raw['id']
    assert_equal [2017,8,2, 20,46,48], raw['created']
    assert_equal 'PHP, PHPUnit', raw['display_name']
    assert_equal 'cyberdojofoundation/php_phpunit', raw['image_name']
    assert_equal 'stateful', raw['runner_choice']
    assert_equal 4, raw['tab_size']
    assert_equal '.php', raw['filename_extension']
    assert_equal 'Anagrams', raw['exercise']
    assert_equal 'PHP-PHPUnit', raw['language']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2017,8,2, 20,46,48]
    assert_display_name 'PHP, PHPUnit'
    assert_image_name 'cyberdojofoundation/php_phpunit'
    assert_runner_choice 'stateful' #!!!!! Should this be updated????
    assert_tab_size 4
    assert_filename_extension '.php'
    assert_exercise 'Anagrams'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2C',
  'old-style kata involving renaming (buffalo, 36 lights)' do
    kata_id = stubbed('421F303E80')

    expected_raw_keys = %w(
      id created tab_size visible_files exercise
      unit_test_framework language browser
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal 'C', raw['language']
    assert_equal 'cassert', raw['unit_test_framework']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created tab_size visible_files exercise
      display_name image_name runner_choice
    )
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2013,2,18, 13,22,10]
    assert_exercise 'Calc_Stats'
    assert_tab_size 4
    assert_display_name 'C (gcc), assert'
    assert_image_name 'cyberdojofoundation/gcc_assert'
    assert_runner_choice 'stateless'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2D',
  'old-style kata involving renaming (wolf, 1 light)' do
    kata_id = stubbed('421AFD7EC5')

    expected_raw_keys = %w(
      id created
      exercise visible_files
      language tab_size unit_test_framework
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal kata_id, raw['id']
    assert_equal [2014,11,20, 9,55,58], raw['created']
    assert_equal 'Poker_Hands', raw['exercise']
    assert_equal 'Ruby-Rspec', raw['language']
    assert_equal 2, raw['tab_size']
    assert_equal 'ruby_rspec', raw['unit_test_framework']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created exercise visible_files tab_size
      display_name image_name runner_choice
    )
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2014,11,20, 9,55,58]
    assert_exercise 'Poker_Hands'
    assert_tab_size 2
    assert_display_name 'Ruby, RSpec'
    assert_image_name 'cyberdojofoundation/ruby_rspec'
    assert_runner_choice 'stateless'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2E',
  'old-style kata not involving renaming (hummingbird, 0 lights)' do
    kata_id = stubbed('420BD5D5BE')

    expected_raw_keys = %w(
      id created exercise visible_files
      language tab_size unit_test_framework
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal kata_id, raw['id']
    assert_equal [2016,8,1, 22,54,33], raw['created']
    assert_equal 'Fizz_Buzz', raw['exercise']
    assert_equal 'Python-py.test', raw['language']
    assert_equal 4, raw['tab_size']
    assert_equal 'python_pytest', raw['unit_test_framework']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created exercise visible_files tab_size
      display_name image_name runner_choice
    )
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2016,8,1, 22,54,33]
    assert_exercise 'Fizz_Buzz'
    assert_tab_size 4
    assert_display_name 'Python, py.test'
    assert_image_name 'cyberdojofoundation/python_pytest'
    assert_runner_choice 'stateless'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2F',
  'new-style kata not involving renaming (spider, 8 lights) with red_amber_green property' do
    kata_id = stubbed('5A0F824303')

    expected_raw_keys = %w(
      id created
      display_name exercise image_name visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language red_amber_green
    )
    raw = raw_manifest(kata_id)
    assert_equal expected_raw_keys.sort, raw.keys.sort
    assert_equal kata_id, raw['id']
    assert_equal [2016,11,23, 8,34,28], raw['created']
    assert_equal 'Python, behave', raw['display_name']
    assert_equal 'Python-behave', raw['language']
    assert_equal 'Reversi', raw['exercise']
    assert_equal '.py', raw['filename_extension']
    assert_equal 4, raw['tab_size']

    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      runner_choice
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2016,11,23, 8,34,28]
    assert_exercise 'Reversi'
    assert_filename_extension('.py')
    assert_tab_size 4
    assert_display_name 'Python, behave'
    assert_image_name 'cyberdojofoundation/python_behave'
    assert_runner_choice 'stateless'
  end

  private # = = = = = = = = = = = = = = =

  def assert_id(expected)
    key = 'id'
    assert_equal expected, @manifest[key], key
  end

  def assert_created(expected)
    key = 'created'
    assert_equal expected, @manifest[key], key
  end

  def assert_display_name(expected)
    key = 'display_name'
    assert_equal expected, @manifest[key], key
  end

  def assert_exercise(expected)
    key = 'exercise'
    assert_equal expected, @manifest[key], key
  end

  def assert_filename_extension(expected)
    key = 'filename_extension'
    assert_equal expected, @manifest[key], key
  end

  def assert_image_name(expected)
    key = 'image_name'
    assert_equal expected, @manifest[key], key
  end

  def assert_runner_choice(expected)
    key = 'runner_choice'
    assert_equal expected, @manifest[key], key
  end

  def assert_tab_size(expected)
    key = 'tab_size'
    assert_equal expected, @manifest[key], key
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def stubbed(kata_id)
    @id_generator = IdGeneratorStub.new
    id_generator.stub(kata_id)
    # DONT call storer.create_kata()
    # The test rig is volume-mounting known katas
    kata_id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def raw_manifest(kata_id)
    outer = kata_id[0..1]
    inner = kata_id[2..-1]
    dir = [ENV['CYBER_DOJO_KATAS_ROOT'],outer,inner].join('/')
    JSON.parse(IO.read(dir + '/manifest.json'))
  end

end
