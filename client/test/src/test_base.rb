require_relative 'hex_mini_test'
require_relative '../../src/storer_service'

class TestBase < HexMiniTest

  def kata_create(manifest)
    storer.kata_create(manifest)
  end

  def kata_exists?(kata_id)
    storer.kata_exists?(kata_id)
  end

  def kata_manifest(kata_id)
    storer.kata_manifest(kata_id)
  end

  def kata_increments(kata_id)
    storer.kata_increments(kata_id)
  end

  # - - - - - - - - - - - - - - -

  def katas_completed(partial_id)
    storer.katas_completed(partial_id)
  end

  def katas_completions(outer_id)
    storer.katas_completions(outer_id)
  end

  # - - - - - - - - - - - - - - -

  def avatar_exists?(kata_id, avatar_name)
    storer.avatar_exists?(kata_id, avatar_name)
  end

  def avatar_start(kata_id, avatar_names)
    storer.avatar_start(kata_id, avatar_names)
  end

  def avatars_started(kata_id)
    storer.avatars_started(kata_id)
  end

  # - - - - - - - - - - - - - - -

  def avatar_ran_tests(kata_id, avatar_name, files, now, stdout, stderr, colour)
    storer.avatar_ran_tests(kata_id, avatar_name, files, now, stdout, stderr, colour)
  end

  # - - - - - - - - - - - - - - -

  def avatar_increments(kata_id, avatar_name)
    storer.avatar_increments(kata_id, avatar_name)
  end

  def avatar_visible_files(kata_id, avatar_name)
    storer.avatar_visible_files(kata_id, avatar_name)
  end

  # - - - - - - - - - - - - - - -

  def tag_fork(kata_id, avatar_name, tag, now)
    storer.tag_fork(kata_id, avatar_name, tag, now)
  end

  def tag_visible_files(kata_id, avatar_name, tag)
    storer.tag_visible_files(kata_id, avatar_name, tag)
  end

  def tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
    storer.tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
  end

  private

  def storer
    StorerService.new
  end

end
