
class KataIdGenerator

  def initialize(external)
    @id_generator = external.id_generator
    @storer = external.storer
  end

  def id
    #TODO: only generate valid kata-ids
    @id_generator.id
  end

end

