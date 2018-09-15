require_relative 'http_json_service'

class StorerService

  def kata_exists?(kata_id)
    get(__method__, kata_id)
  end

  def kata_create(manifest)
    post(__method__, manifest)
  end

  def kata_manifest(kata_id)
    get(__method__, kata_id)
  end

  def kata_increments(kata_id)
    get(__method__, kata_id)
  end

  # - - - - - - - - - - - -

  def katas_completed(partial_id)
    get(__method__, partial_id)
  end

  def katas_completions(outer_id)
    get(__method__, outer_id)
  end

  # - - - - - - - - - - - -

  def avatar_exists?(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def avatar_start(kata_id, avatars_names)
    post(__method__, kata_id, avatars_names)
  end

  def avatars_started(kata_id)
    get(__method__, kata_id)
  end

  # - - - - - - - - - - - -

  def avatar_ran_tests(kata_id, avatar_name, files, now, stdout, stderr, colour)
    post(__method__, kata_id, avatar_name, files, now, stdout, stderr, colour)
  end

  # - - - - - - - - - - - -

  def avatar_increments(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  def avatar_visible_files(kata_id, avatar_name)
    get(__method__, kata_id, avatar_name)
  end

  # - - - - - - - - - - - -

  def tag_fork(kata_id, avatar_name, tag, now)
    get(__method__, kata_id, avatar_name, tag, now)
  end

  def tag_visible_files(kata_id, avatar_name, tag)
    get(__method__, kata_id, avatar_name, tag)
  end

  def tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
    get(__method__, kata_id, avatar_name, was_tag, now_tag)
  end

  private

  include HttpJsonService

  def hostname
    'storer'
  end

  def port
    4577
  end

end
