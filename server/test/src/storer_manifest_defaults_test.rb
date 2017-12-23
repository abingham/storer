require_relative 'test_base'

class StorerManifestDefaultsTest < TestBase

  def self.hex_prefix
    'DA9D06E'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '344',
  'filename_extension defaults to empty string' do
    assert_default 'filename_extension', ''
  end

  test '345',
  'highlight_filenames defaults to empty array' do
    assert_default 'highlight_filenames', []
  end

  test '346',
  'runner_choice defaults to stateless' do
    assert_default 'runner_choice', 'stateless'
  end

  test '347',
  'max_seconds defaults to 10' do
    assert_default 'max_seconds', 10
  end

  test '348',
  'lowlight_filenames defaults to specific 4 files' do
    specific = %w( cyber-dojo.sh makefile Makefile unity.license.txt )
    assert_default 'lowlight_filenames', specific
  end

  test '349',
  'progress_regexs defaults to empty array' do
    assert_default 'progress_regexs', []
  end

  test '34A',
  'tab_size defaults to 4' do
    assert_default 'tab_size', 4
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def assert_default(name, expected)
    manifest = create_manifest(kata_id)
    manifest.delete(name)
    storer.create_kata(manifest)
    assert_equal expected, storer.kata_manifest(kata_id)[name]
  end

end
