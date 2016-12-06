require_relative './../hex_mini_test'
require_relative './../../src/storer_http_adapter'

class ClientTestBase < HexMiniTest

  include StorerHttpAdapter

  def kata_exists?(kata_id)
    kata_exists(kata_id)
  end

end
