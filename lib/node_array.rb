# frozen_string_literal: true

require_relative './node'

##
# An array of nodes that acts like a String.
#
# The difference between this and a real String
# is that each character (or substrings) in this
# 'String' can be passed by reference.
class NodeArray < Array
  def to_s
    map(&:to_s).join
  end
end
