require_relative 'test_base'

class ExternalsTest < TestBase

  include Externals

  def self.hex_prefix
    '7A9B4'
  end

  # - - - - - - - - - - - - - - - - -

  test '543',
  'default storer is Storer' do
    assert_equal 'Storer', storer.class.name
  end

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
  'default shell is BashSheller' do
    assert_equal 'BashSheller', shell.class.name
  end

end
