require_relative 'base58'

class IdGenerator

  def generate
    Base58.string(10)
  end

end
