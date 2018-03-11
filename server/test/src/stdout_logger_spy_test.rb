require_relative 'test_base'
require_relative 'stdout_logger_spy'

class StdoutLoggerSpyTest < TestBase

  def self.hex_prefix
    'CD476'
  end

  test '20C',
  'logged message is spied' do
    @log = StdoutLoggerSpy.new(nil)
    assert_equal [], log.spied
    log << 'hello'
    assert_equal ['hello'], log.spied
    log << 'world'
    assert_equal ['hello','world'], log.spied
  end

end
