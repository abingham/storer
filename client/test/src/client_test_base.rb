require_relative './../hex_mini_test'
require_relative './../../src/storer_http_adapter'

class ClientTestBase < HexMiniTest

  def kata_exists?(kata_id)
    json = storer.kata_exists?(kata_id)
    json['kata_exists']
  end

  def create_kata(manifest)
    storer.create_kata(manifest)
  end

  def kata_manifest(kata_id)
    json = storer.kata_manifest(kata_id)
    json['kata_manifest']
  end

  def completed(id)
    json = storer.completed(id)
    json['completed']
  end

  def ids_for(outer_dir) # TODO: refactor to completions(id)
    json = storer.ids_for(outer_dir)
    json['ids_for']
  end

  def kata_started_avatars(kata_id)
    json = storer.kata_started_avatars(kata_id)
    json['kata_started_avatars']
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def storer; StorerHttpAdapter.new; end

end
