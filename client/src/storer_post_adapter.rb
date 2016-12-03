require 'json'
require 'net/http'

class StorerPostAdapter

  def kata_exists?(kata_id)
    get('kata_exists', { kata_id:kata_id })
  end

  private

  def get(method, args)
    uri = URI.parse('http://storer_server:4577/' + method.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.content_type = 'application/json'
    request.body = args.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

  def post(method, args)
    uri = URI.parse('http://storer_server:4577/' + method.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'application/json'
    request.body = args.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

end


