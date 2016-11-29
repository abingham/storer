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
    assert_equal 10, test_id.length
    refute storer.kata_exists?(test_id)
  end

  test 'D70',
  'kata_exists?(good-id) true' do
    kata_id = 'CE121BE38A'
    assert_equal 10, kata_id.length
    make_dir(kata_id)
    assert storer.kata_exists?(kata_id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def make_dir(id)
    outer = id.upcase[0..1]
    inner = id.upcase[2..-1]
    disk[storer.path + '/' + outer + '/' + inner].make
  end

end

