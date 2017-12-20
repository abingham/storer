require_relative 'test_base'

class StorerKataManifestTest < TestBase

  def self.hex_prefix
    '33DD9'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2A',
  'new-style kata not involving renaming (dolphin, 20 lights)' do
    kata_id = '420B05BA0A'
    assert_dir_exists kata_id
    @manifest = storer.kata_manifest(kata_id)
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2017,10,25,13,31,50]
    assert_runner_choice 'stateless'
    assert_image_name 'cyberdojofoundation/java_junit'
    assert_display_name 'Java, JUnit'
    assert_filename_extension('.java')
    assert_language 'Java-JUnit'
    assert_tab_size 4
    assert_exercise '(Verbal)'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -


  test 'E2B',
  'new-style kata not involving renaming (snake, 0 lights)' do
    kata_id = '420F2A2979'
    assert_dir_exists kata_id
    @manifest = storer.kata_manifest(kata_id)
    assert_equal expected_keys.sort, @manifest.keys.sort
    assert_id kata_id
    assert_created [2017,8,2,20,46,48]
    assert_runner_choice 'stateful'
    assert_image_name 'cyberdojofoundation/php_phpunit'
    assert_display_name 'PHP, PHPUnit'
    assert_filename_extension('.php')
    assert_language 'PHP-PHPUnit'
    assert_tab_size 4
    assert_exercise 'Anagrams'
  end


  #puts JSON.pretty_generate(@manifest)

  private # = = = = = = = = = = = = = = =

  def assert_dir_exists(kata_id)
    outer = kata_id[0..1]
    inner = kata_id[2..-1]
    assert disk["#{cyber_dojo_katas_root}/#{outer}/#{inner}"].exists?
  end

  def assert_id(expected)
    assert_equal expected, id, 'id'
  end

  def assert_created(expected)
    assert_equal expected, created, 'created'
  end

  def assert_runner_choice(expected)
    assert_equal expected, runner_choice, 'runner_choice'
  end

  def assert_image_name(expected)
    assert_equal expected, image_name, 'image_name'
  end

  def assert_display_name(expected)
    assert_equal expected, display_name, 'display_name'
  end

  def assert_filename_extension(expected)
    assert_equal expected, filename_extension, 'filename_extension'
  end

  def assert_language(expected)
    assert_equal expected, language, 'language'
  end

  def assert_tab_size(expected)
    assert_equal expected, tab_size, 'tab_size'
  end

  def assert_exercise(expected)
    assert_equal expected, exercise, 'exercise'
  end

  # - - - - - - - - - - - - - - - - - - - -

  def id
    @manifest[__method__.to_s]
  end

  def created
    @manifest[__method__.to_s]
  end

  def runner_choice
    @manifest[__method__.to_s]
  end

  def image_name
    @manifest[__method__.to_s]
  end

  def display_name
    @manifest[__method__.to_s]
  end

  def filename_extension
    @manifest[__method__.to_s]
  end

  def language
    @manifest[__method__.to_s]
  end

  def tab_size
    @manifest[__method__.to_s]
  end

  def exercise
    @manifest[__method__.to_s]
  end

  # - - - - - - - - - - - - - - - - - - - -

  def expected_keys
    %w(
      id
      created
      runner_choice
      image_name
      display_name
      filename_extension
      progress_regexs
      highlight_filenames
      lowlight_filenames
      language
      tab_size
      visible_files
      exercise
    )
  end

end
