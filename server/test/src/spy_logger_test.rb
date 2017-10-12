require_relative 'test_base'
require_relative 'spy_logger'

class SpyLoggerTest < TestBase

  def self.hex_prefix
    'CD4'
  end

  test '20C',
  'logged message is spied' do
    @log = SpyLogger.new(nil)
    assert_equal [], log.spied
    log << 'hello'
    assert_equal ['hello'], log.spied
    log << 'world'
    assert_equal ['hello','world'], log.spied
  end

end
