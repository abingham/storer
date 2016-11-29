require_relative './storer_test_base'

class ExternalDiskWriterTest < StorerTestBase

  def self.hex_prefix; 'FDF13'; end

  test '437',
  'dir.name does not ends in /' do
    dir = disk['/tmp/437']
    assert_equal '/tmp/437', dir.name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0DB',
  'dir.exists? is false before dir.make and true after' do
    dir = disk['/tmp/0DB']
    refute dir.exists?
    assert dir.make
    assert dir.exists?
    refute dir.make
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test '61F',
  'dir.exists?(filename) false when file does not exist, true when it does' do
    dir = disk['/tmp/61F']
    dir.make
    refute dir.exists?(filename )
    dir.write(filename, content)
    assert dir.exists?(filename)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D4C',
  'what gets written gets read back' do
    dir = disk['/tmp/D4C']
    dir.make
    dir.write(filename, content)
    assert_equal content, dir.read(filename)
  end

  private

  def filename
    'limerick.txt'
  end

  def content
    'the boy stood on the burning deck'
  end

end
