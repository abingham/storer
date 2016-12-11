require_relative './../hex_mini_test'
require_relative './../../src/storer_service'

class ClientTestBase < HexMiniTest

  include StorerService

  def kata_exists?(kata_id)
    kata_exists(kata_id)
  end

  def avatar_exists?(kata_id, avatar_name)
    avatar_exists(kata_id, avatar_name)
  end

end
