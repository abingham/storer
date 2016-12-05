require_relative './../hex_mini_test'
require_relative './../../src/storer_http_adapter'

class ClientTestBase < HexMiniTest

  def create_kata(manifest)
    poster(__method__, manifest)
  end

  def kata_exists?(kata_id)
    getter('kata_exists', kata_id)
  end

  def kata_manifest(kata_id)
    getter(__method__, kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def completed(id)
    getter(__method__, id)
  end

  def ids_for(outer_dir) # TODO: refactor to completions(id)
    getter(__method__, outer_dir)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def kata_started_avatars(kata_id)
    getter(__method__, kata_id)
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def getter(caller, *args)
    name = caller.to_s
    http.send(name, *args)[name]
  end

  def poster(caller, *args)
    name = caller.to_s
    http.send(name, *args)
  end

  def http; StorerHttpAdapter.new; end

end
