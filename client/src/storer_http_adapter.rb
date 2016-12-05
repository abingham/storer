require 'json'
require 'net/http'

class StorerHttpAdapter

  def create_kata(manifest)
    post(__method__, manifest)
  end

  # - - - - - - - - - - - -

  def completed(id)
    get(__method__, id)
  end

  def completions(id)
    get(__method__, id)
  end

  # - - - - - - - - - - - -

  def kata_exists(kata_id)
    get(__method__, kata_id)
  end

  def kata_manifest(kata_id)
    get(__method__, kata_id)
  end

  def kata_start_avatar(kata_id, avatar_names)
    post(__method__, kata_id, avatar_names)
  end

  def kata_started_avatars(kata_id)
    get(__method__, kata_id)
  end

  # - - - - - - - - - - - -

  def avatar_increments(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def avatar_visible_files(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def avatar_ran_tests(kata_id, avatar_name, delta, files, now, output, colour)
    post(__method__, kata_id, avatar_name, delta, files, now, output, colour)
  end

  def tag_visible_files(kata_id, avatar_name, tag)
    get(__method__, kata_id, avatar_name, tag)
  end

  private

  def get(method, *args)
    http(method, args_hash(method, *args)) { |uri| Net::HTTP::Get.new(uri) }
  end

  def post(method, *args)
    http(method, args_hash(method, *args)) { |uri| Net::HTTP::Post.new(uri) }
  end

  def args_hash(method, *args)
    hash = {}
    self.class.instance_method(method).parameters.each_with_index do |entry,index|
      hash[entry[1]] = args[index]
    end
    hash
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


