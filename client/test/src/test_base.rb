require_relative 'hex_mini_test'
require_relative '../../src/storer_service'

class TestBase < HexMiniTest

  def path
    storer.path
  end

  def create_kata(manifest)
    storer.create_kata(manifest)
  end

  def kata_exists?
    storer.kata_exists?(kata_id)
  end

  def kata_manifest
    storer.kata_manifest(kata_id)
  end

  def kata_increments
    storer.kata_increments(kata_id)
  end

  # - - - - - - - - - - - - - - -

  def completed(kata_id)
    storer.completed(kata_id)
  end

  def completions(kata_id)
    storer.completions(kata_id)
  end

  # - - - - - - - - - - - - - - -

  def avatar_exists?(avatar_name)
    storer.avatar_exists?(kata_id, avatar_name)
  end

  def start_avatar(avatar_names)
    storer.start_avatar(kata_id, avatar_names)
  end

  def started_avatars
    storer.started_avatars(kata_id)
  end

  # - - - - - - - - - - - - - - -

  def avatar_ran_tests(avatar_name, files, now, output, colour)
    storer.avatar_ran_tests(kata_id, avatar_name, files, now, output, colour)
  end

  # - - - - - - - - - - - - - - -

  def avatar_increments(avatar_name)
    storer.avatar_increments(kata_id, avatar_name)
  end

  def avatar_visible_files(avatar_name)
    storer.avatar_visible_files(kata_id, avatar_name)
  end

  # - - - - - - - - - - - - - - -

  def tag_visible_files(avatar_name, tag)
    storer.tag_visible_files(kata_id, avatar_name, tag)
  end

  def tags_visible_files(avatar_name, was_tag, now_tag)
    storer.tags_visible_files(kata_id, avatar_name, was_tag, now_tag)
  end

  private

  def storer
    StorerService.new
  end

  def kata_id
    # reversed so I don't get common outer(id)s
    test_id.reverse + ('0' * (10-test_id.length))
  end

end
