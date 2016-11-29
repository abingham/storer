require_relative './storer_test_base'

class HostDiskStorerTest < StorerTestBase

  def self.hex_prefix; 'E4FDA'; end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '72D',
  "Storer's parent object is the test object" do
    assert_equal self, storer.parent
  end

  private

end

