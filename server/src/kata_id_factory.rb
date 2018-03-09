require 'uuidtools'

class KataIdFactory

  def initialize(external)
    #@shell = external.shell
  end

  def id
    # 10 hex chars gives 16^10 possibilities
    # viz 1,099,511,627,776 possibilities
    # which is more than enough as long as
    # uuidgen is reasonably well behaved.
    #
    # 6 hex chars are all that need to be entered
    # to enable id-auto-complete which is
    # 16^6 == 16,777,216 possibilities.
    UUIDTools::UUID.random_create.to_s.strip.delete('-')[0...10].upcase
  end

end

