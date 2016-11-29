require_relative './storer_test_base'

class ExternalDiskWriterTest < StorerTestBase

  def self.hex_prefix; 'FDF13'; end

  test 'D4C',
  'what gets written gets read back' do
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |tmp_dir|
      pathed_filename = tmp_dir + '/limerick.txt'
      content = 'the boy stood on the burning deck'
      disk.write(pathed_filename, content)
      File.open(pathed_filename, 'r') { |fd| assert_equal content, fd.read }
    end
  end

end
