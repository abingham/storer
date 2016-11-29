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

  test 'F72',
  'git.commit' do
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |path|
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

  test '31A',
  'git.diff' do
    Dir.mktmpdir(ENV['CYBER_DOJO_TEST_HEX_ID']) do |avatar_path|
      git.setup(avatar_path, user_name, user_email)
      sandbox_path = avatar_path + '/sandbox'
      shell.exec("mkdir #{sandbox_path}")
      filename = 'limerick.txt'
      content = 'the boy stood on the burning deck' + "\n"
      disk.write(sandbox_path + '/' + filename, content)
      git.add(sandbox_path, filename)
      git.commit(avatar_path, was_tag=0)
      content += 'he gave a cough, his leg fell off' + "\n"
      disk.write(sandbox_path + '/' + filename, content)
      git.add(sandbox_path, filename)
      git.commit(avatar_path, now_tag=1)
      expected = [
        'diff --git a/sandbox/limerick.txt b/sandbox/limerick.txt',
        'index 334ac44..e9ab257 100644',
        '--- a/sandbox/limerick.txt',
        '+++ b/sandbox/limerick.txt',
        '@@ -1 +1,2 @@',
        ' the boy stood on the burning deck',
        '+he gave a cough, his leg fell off'
      ]
      @stdout = git.diff(avatar_path, was_tag, now_tag)
      assert_stdout expected.join("\n")+"\n"
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

  test '7A3E16',
  'shell.cd_exec for git.rm' do
    filename = 'wibble.c'
    expect(["git rm '#{filename}'"])
    git.rm(path, filename)
  end

=end

end
