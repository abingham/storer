require_relative './storer_test_base'

class HostDiskStorerTest < StorerTestBase

  def self.hex_prefix; 'E4FDA'; end

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
    nine = '60408161A'
    assert_equal 9, nine.length
    refute storer.kata_exists?(nine)
  end

  test '8F9',
  'kata_exists?(id) for string 10 chars long but not all hex is false' do
    ten = '60408161AG'
    assert_equal 10, ten.length
    refute storer.kata_exists?(ten)
  end

=begin
  test '79A',
  'kata_exists?(id) false' do
    ten = 'CE121BE38A'
    assert_equal 10, ten.length
    refute storer.kata_exists?(ten)
  end
=end

  private

end

