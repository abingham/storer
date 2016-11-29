require_relative './storer_test_base'
require_relative './spy_logger'

class ExternalGitterTest < StorerTestBase

  def self.hex_prefix; 'C89'; end

  def hex_setup
    @log = SpyLogger.new(self)
  end

  # - - - - - - - - - - - - - - - - -

  test 'DC3',
  'git.setup' do
    hex_tmp_dir do |path|
      git.setup(path, user_name, user_email)
      cd_exec(path, 'git status')
      assert_status 0
      assert_stdout_include  'On branch master'
      assert_stdout_include  'Initial commit'
      assert_stderr ''
      assert_log []
      cd_exec(path, 'git config user.name')
      assert_success user_name + "\n"
      cd_exec(path, 'git config user.email')
      assert_success user_email + "\n"
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F2F',
  'git.add' do
    hex_tmp_dir do |path|
      git.setup(path, user_name, user_email)
      filename = 'limerick.txt'
      content = 'the boy stood on the burning deck'
      disk.write(path + '/' + filename, content)
      git.add(path, filename)
      cd_exec(path, 'git status')
      assert_status 0
      assert_stdout_include 'new file:   limerick.txt'
      assert_stderr ''
      assert_log []
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F72',
  'git.commit' do
    hex_tmp_dir do |path|
      git.setup(path, user_name, user_email)
      filename = 'limerick.txt'
      content = 'the boy stood on the burning deck'
      disk.write(path + '/' + filename, content)
      git.add(path, filename)
      git.commit(path, tag=0)
      cd_exec(path, 'git log')
      assert_status 0
      assert_match /commit (\h*)/, @stdout
      assert_match /Author: lion <lion@cyber-dojo.org>/, @stdout
      assert_match /Date:\s\s\s(.*)/, @stdout
      assert_match /\s\s\s0/, @stdout
      assert_stderr ''
      assert_log []
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '6F8',
  'git.show' do
    hex_tmp_dir do |path|
      git.setup(path, user_name, user_email)
      filename = 'limerick.txt'
      content = 'the boy stood on the burning deck'
      disk.write(path + '/' + filename, content)
      git.add(path, filename)
      git.commit(path, tag=0)
      assert_equal content, git.show(path, "#{tag}:#{filename}")
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '7A3',
  'for git.rm' do
    hex_tmp_dir do |path|
      #...
    end
  end

  private

  def hex_tmp_dir
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |path|
      yield path
    end
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
