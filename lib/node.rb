# frozen_string_literal: true

##
# Wrapper class that holds a value.
#
# It's purpose is to allow values to be passed by
# reference.
class Node
  attr_accessor :value

  def initialize(value = '')
    self.value = value
  end

  def to_s
    value.to_s
  end

  def ==(other)
    value == other.value
  end
end
