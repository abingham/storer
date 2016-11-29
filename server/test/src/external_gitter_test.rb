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
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |path|
      git.setup(path, user_name, user_email)
      cd_exec(path, 'git status')
      assert_status 0
      assert_stdout_include  'On branch master'
      assert_stdout_include  'Initial commit'
      assert_stderr ''
      assert_log []
      cd_exec(path, 'git config user.name')
      assert_success 'lion' + "\n"
      cd_exec(path, 'git config user.email')
      assert_success 'lion@cyber-dojo.org' + "\n"
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F2F',
  'git.add' do
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |path|
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

  private

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


=begin
  # - - - - - - - - - - - - - - - - -

  test '6F8B85',
  'shell.cd_exec for git.show' do
    options = '--quiet'
    expect(["git show #{options}"])
    git.show(path, options)
  end

  # - - - - - - - - - - - - - - - - -

  test '31A9A2',
  'shell.cd_exec for git.diff' do
    was_tag = 2
    now_tag = 3
    options = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    expect(["git diff #{options}"])
    git.diff(path, was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - -

  test '7A3E16',
  'shell.cd_exec for git.rm' do
    filename = 'wibble.c'
    expect(["git rm '#{filename}'"])
    git.rm(path, filename)
  end

  # - - - - - - - - - - - - - - - - -

  test 'F728AB',
  'shell.cd_exec for git.commit' do
    tag = 6
    expect([
      "git commit -a -m #{tag} --quiet",
      'git gc --auto --quiet',
      "git tag -m '#{tag}' #{tag} HEAD"
    ])
    git.commit(path, tag)
  end
=end

end
