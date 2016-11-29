require_relative './storer_test_base'

class HostDiskStorerTest < StorerTestBase

  def self.hex_prefix; 'E4FDA'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '72D',
  "Storer's parent object is the test object" do
    assert_equal self, storer.parent
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '218',
  'path is set to /tmp in docker-compose.yml' do
    assert_equal '/tmp', storer.path
  end

  private

end

