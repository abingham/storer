
class StorerStub

  def sha
    "hello from #{self.class.name}.#{__method__}"
  end

  def kata_exists?(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def kata_create(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def kata_delete(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def kata_manifest(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def kata_increments(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def katas_completed(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def katas_completions(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  # - - - - - - - - - - - - - - - -

  def avatar_start(_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def avatars_started(_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def avatar_exists?(_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def avatar_increments(_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def avatar_visible_files(_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def avatar_ran_tests(_,_,_,_,_,_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  # - - - - - - - - - - - - - - - -

  def tag_fork(_,_,_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def tag_visible_files(_,_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

  def tags_visible_files(_,_,_,_)
    "hello from #{self.class.name}.#{__method__}"
  end

end
