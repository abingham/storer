require_relative 'storer_service'

class Demo

  def call(_env)
    [ 200, { 'Content-Type' => 'text/html' }, [ 'TODO' ] ]
  end

  private

  def storer
    StorerService.new
  end

end


