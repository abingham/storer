
require_relative './nearest_external'

class ExternalGitter

  def initialize(parent)
    @parent = parent
  end

  # queries

  attr_reader :parent

  def show(path, options)
    output_of(path, "git show #{options}")
  end

  def diff(path, n, m)
    options = [
      '--ignore-space-at-eol',
      '--find-copies-harder',
      "#{n}",
      "#{m}",
      'sandbox'
    ].join(space = ' ')
    output_of(path, "git diff #{options}")
  end

  # modifiers

  def setup(path, user_name, user_email)
    commands = [
      'git init --quiet',
      "git config user.name #{quoted(user_name)}",
      "git config user.email #{quoted(user_email)}"
    ]
    commands.each { |command| cd_exec(path, command) }
  end

  def rm(path, filename)
    cd_exec(path, "git rm #{quoted(filename)}")
  end

  def add(path, filename)
    cd_exec(path, "git add #{quoted(filename)}")
  end

  def commit(path, tag)
    commands = [
      "git commit -a -m #{tag} --quiet",
      'git gc --auto --quiet',
      "git tag -m '#{tag}' #{tag} HEAD"
    ]
    commands.each { |command| cd_exec(path, command) }
  end

  private

  def cd_exec(path, command)
    shell.cd_exec(path, command)
  end

  include NearestExternal
  def shell; nearest_external(:shell); end

  def quoted(s)
    "'" + s + "'"
  end

  def output_of(path, command)
    stdout,_stderr,_status = cd_exec(path, command)
    stdout
  end

end
