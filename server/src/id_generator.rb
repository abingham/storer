require 'uuidtools'

# 10 hex chars gives 16^10 possibilities
# viz 1,099,511,627,776 possibilities
# which is more than enough as long as
# uuidgen is reasonably well behaved.

class IdGenerator

  def id
    raw = UUIDTools::UUID.random_create.to_s
    raw.strip.delete('-')[0...10].upcase
  end

end
