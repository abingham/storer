require_relative 'storer_test_base'

class ExternalsTest < StorerTestBase

  include Externals

  def self.hex_prefix; '7A9'; end

  # - - - - - - - - - - - - - - - - -

  test '920',
  'default disk is DiskWriter' do
    assert_equal 'DiskWriter', disk.class.name
  end

  # - - - - - - - - - - - - - - - - -

  test '3EC',
  'default log is StdoutLogger' do
    assert_equal 'StdoutLogger', log.class.name
  end

  # - - - - - - - - - - - - - - - - -

  test '1B1',
  'default shell is Sheller' do
    assert_equal 'Sheller', shell.class.name
  end

  # - - - - - - - - - - - - - - - - -

  test 'DAA',
  'default gitter is Gitter' do
    assert_equal 'Gitter', git.class.name
  end

end
