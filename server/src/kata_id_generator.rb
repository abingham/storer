
class KataIdGenerator

  def initialize(external)
    @external = external
  end

  def generate
    id = nil
    loop do
      id = id_generator.generate
      break if valid?(id)
    end
    id
  end

  private

  def valid?(id)
    storer.valid_id?(id) &&
      !storer.kata_exists?(id)
      #&& storer.completable(id)
  end

  def id_generator
    @external.id_generator
  end

  def storer
    @external.storer
  end

end

