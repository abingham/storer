
class IdGeneratorTest < TestBase

  def self.hex_prefix
    '79B84'
  end

  # - - - - - - - - - - - - - - - -

  test '926',
  'blah blah' do
  end


=begin
  test '933',
  'create_kata() with invalid manifest[id] raises' do
    manifest = create_manifest
    assert_invalid_kata_id_raises do |invalid_id|
      manifest['id'] = invalid_id
      storer.create_kata(manifest)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'ABC',
  'create_kata() with duplicate kata_id raises' do
    manifest = create_manifest
    storer.create_kata(manifest)
    error = assert_raises(ArgumentError) {
      storer.create_kata(manifest)
    }
    assert_invalid_kata_id(error)
  end
=end

end