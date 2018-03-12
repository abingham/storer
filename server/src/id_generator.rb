require_relative 'base16'

class IdGenerator

  def generate
    Base16.string(10)
  end

end
