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

  #- - - - - - - - - - - - - - - - - - - - - - - -

  def assert_default(name, expected)
    manifest = create_manifest(kata_id)
    manifest.delete(name)
    storer.create_kata(manifest)
    assert_equal expected, storer.kata_manifest(kata_id)[name]
  end

end
