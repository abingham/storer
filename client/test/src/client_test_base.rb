require_relative './../hex_mini_test'
require_relative './../../src/storer_post_adapter'

class ClientTestBase < HexMiniTest

  def kata_exists?(kata_id)
    @json = storer.kata_exists?(kata_id)
    status
  end

  def create_kata(manifest)
    @json = storer.create_kata(manifest)
    status
  end

  def kata_manifest(kata_id)
    @json = storer.kata_manifest(kata_id)
    JSON.parse(stdout)
  end

  def completed(id)
    @json = storer.completed(id)
    stdout
  end

  def ids_for(outer_dir) # TODO: refactor to completions(id)
    @json = storer.ids_for(outer_dir)
    stdout
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def storer; StorerPostAdapter.new; end

  def json; @json; end
  def status; json['status']; end
  def stdout; json['stdout']; end
  def stderr; json['stderr']; end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def success; 0; end

  def assert_success; assert_equal success, status, json.to_s; end

  def assert_stdout(expected); assert_equal expected, stdout, json.to_s; end
  def assert_stderr(expected); assert_equal expected, stderr, json.to_s; end
  def assert_status(expected); assert_equal expected, status, json.to_s; end

end
