require_relative 'test_base'

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
    assert_no_default 'runner_choice'
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_no_default(name)
    @count ||= 0
    @count += 1
    kata_id = "33DD934A0#{@count}"
    manifest = create_manifest(kata_id)
    manifest.delete(name)
    storer.create_kata(manifest)
    assert_nil storer.kata_manifest(kata_id)[name]
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'E2A',
  'new-style kata not involving renaming (dolphin, 20 lights)' do
    kata_id = '420B05BA0A'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language
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
    assert_language 'Java-JUnit'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2B',
  'new-style kata not involving renaming (snake, 0 lights)' do
    kata_id = '420F2A2979'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name runner_choice visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2017,8,2, 20,46,48]
    assert_display_name 'PHP, PHPUnit'
    assert_exercise 'Anagrams'
    assert_filename_extension '.php'
    assert_image_name 'cyberdojofoundation/php_phpunit'
    assert_runner_choice 'stateful'
    assert_tab_size 4
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2C',
  'old-style kata involving renaming (buffalo, 36 lights)' do
    kata_id = '421F303E80'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      exercise visible_files
      unit_test_framework language browser tab_size
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2013,2,18, 13,22,10] # old!
    assert_language 'C' # no hyphen!
    assert_unit_test_framework 'cassert'
    assert_exercise 'Calc_Stats'
    assert_tab_size 4
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2D',
  'old-style kata involving renaming (wolf, 1 light)' do
    kata_id = '421AFD7EC5'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      exercise visible_files
      language tab_size unit_test_framework
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2014,11,20, 9,55,58]
    assert_language 'Ruby-Rspec' # lowercase s
    assert_unit_test_framework 'ruby_rspec'
    assert_exercise 'Poker_Hands'
    assert_tab_size 2
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2E',
  'old-style kata not involving renaming (hummingbird, 0 lights)' do
    kata_id = '420BD5D5BE'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      exercise visible_files
      language tab_size unit_test_framework
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2016,8,1, 22,54,33]
    assert_language 'Python-py.test'
    assert_unit_test_framework 'python_pytest'
    assert_exercise 'Fizz_Buzz'
    assert_tab_size 4
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2F',
  'new-style kata not involving renaming (spider, 8 lights) with red_amber_green property' do
    kata_id = '5A0F824303'
    @manifest = storer.kata_manifest(kata_id)
    expected_keys = %w(
      id created
      display_name exercise image_name visible_files
      filename_extension highlight_filenames lowlight_filenames progress_regexs tab_size
      language red_amber_green
    )
    assert_equal expected_keys.sort, @manifest.keys.sort

    assert_id kata_id
    assert_created [2016,11,23, 8,34,28]
    assert_language 'Python-behave'
    assert_display_name 'Python, behave'
    assert_exercise 'Reversi'
    assert_filename_extension('.py')
    assert_image_name 'cyberdojofoundation/python_behave'
    assert_tab_size 4
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

  def assert_language(expected)
    key = 'language'
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

  def assert_unit_test_framework(expected)
    key = 'unit_test_framework'
    assert_equal expected, @manifest[key], key
  end

end
