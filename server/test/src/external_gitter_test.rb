require_relative './storer_test_base'
require_relative './spy_logger'

class ExternalGitterTest < StorerTestBase

  def self.hex_prefix; 'C89'; end

  def hex_setup
    @log = SpyLogger.new(self)
  end

  test '65D',
  'retrieval of visible-files in known old-git-format kata' do
    path = storer.path + '/5A/0F824303/spider'
    tag = 1
    filename = 'hiker.py'
    src = git.show(path, "#{tag}:sandbox/#{filename}")
    refute_nil src
    assert src.include? 'class Hiker:'
    assert src.include?   'def answer(self, first, second):'
    assert src.include?     'return first * second'
  end

  private

  def hex_tmp_dir
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |path|
      yield path
    end
  end

  def filename
    'limerick.txt'
  end

  def content
    'the boy stood on the burning deck'
  end

  def user_name
    'lion'
  end

  def user_email
    'lion@cyber-dojo.org'
  end

  def cd_exec(path, command, logging = true)
    @stdout,@stderr,@status = shell.cd_exec(path, command, logging)
  end

  def assert_success(expected)
    assert_status 0
    assert_stdout  expected
    assert_stderr ''
    assert_log []
  end

  def assert_status(expected)
    assert_equal expected, @status
  end

  def assert_stdout_include(expected)
    assert @stdout.include?(expected), @stdout
  end

  def assert_stdout(expected)
    assert_equal expected, @stdout
  end

  def assert_stderr(expected)
    assert_equal expected, @stderr
  end

  def assert_log(expected)
    line = '-' * 40
    expected.unshift(line) unless expected == []
    assert_equal expected, log.spied
  end

end
