require_relative './storer_test_base'

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
    manifest = {
      image_name: 'cyberdojofoundation/python_behave',
      id: kata_id
    }
    storer.create_kata(manifest)
    assert storer.kata_exists?(test_id)
    assert_hash_equal manifest, storer.kata_manifest(kata_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # completed
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ids_for
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def kata_id
    test_id
  end

  def assert_hash_equal(expected, actual)
    assert_equal expected.size, actual.size
    expected.each do |symbol,value|
      assert_equal value, actual[symbol.to_s]
    end
  end

end
