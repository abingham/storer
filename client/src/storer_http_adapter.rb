require 'json'
require 'net/http'

class StorerHttpAdapter

  def kata_exists?(kata_id)
    get('kata_exists', { kata_id:kata_id })
  end

  def create_kata(manifest)
    post(__method__, { manifest:manifest })
  end

  def kata_manifest(kata_id)
    get(__method__, { kata_id:kata_id })
  end

  def completed(id)
    get(__method__, { id:id })
  end

  def ids_for(id)
    get(__method__, { id:id })
  end

  private

  def get(method, args)
    http(method, args) { |uri| Net::HTTP::Get.new(uri) }
  end

  def post(method, args)
    http(method, args) { |uri| Net::HTTP::Post.new(uri) }
  end

  def http(method, args)
    uri = URI.parse('http://storer_server:4577/' + method.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    request = yield uri.request_uri
    request.content_type = 'application/json'
    request.body = args.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

end


