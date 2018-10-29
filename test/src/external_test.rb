require_relative 'test_base'

class ExternalTest < TestBase

  def self.hex_prefix
    '7A9B4'
  end

  # - - - - - - - - - - - - - - - - -

  test '543',
  'default externals are set' do
    assert_equal 'DiskWriter',      disk.class.name
    assert_equal 'IdGenerator',     id_generator.class.name
    assert_equal 'KataIdGenerator', kata_id_generator.class.name
    assert_equal 'StdoutLogger',    log.class.name
    assert_equal 'BashSheller',     shell.class.name
    assert_equal 'Storer',          storer.class.name
  end

end
