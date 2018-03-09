require_relative '../../src/id_generator'

class IdGeneratorStub

  def initialize
    @stubbed = []
  end

  def stub(*kata_ids)
    @stubbed = kata_ids
  end

  def generate
    if @stubbed != []
      @stubbed.shift
    else
      IdGenerator.new.generate
    end
  end

end
