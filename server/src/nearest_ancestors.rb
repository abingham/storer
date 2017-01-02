
module NearestAncestors

  def nearest_ancestors(symbol, my = self)
    loop {
      no_parent = "#{my.class.name} does not have a parent"
      fail no_parent unless my.respond_to? :parent
      my = my.parent
      return my.send(symbol) if my.respond_to? symbol
    }
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assumes the object (which included the module) has a parent and
# repeatedly chains back parent to parent to parent until it gets
# to an object with the required property, or runs out of parents.
# Properties accessed in this way:
#   o) shell - executes shell commands
#   o) disk  - file-system directories and file read/write
#   o) log   - stdout based logging
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Allows classes representing external objects to easily access
# each other as well.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
