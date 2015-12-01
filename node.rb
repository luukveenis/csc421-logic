# Simple class to represent nodes in the parse tree
class Node
  attr_reader :val, :left, :right

  def initialize val, left, right
    @val = val
    @left = left
    @right = right
  end

  def leaf?
    @left.nil? && @right.nil?
  end
end
