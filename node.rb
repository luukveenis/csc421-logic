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

  def unary?
    !@left.nil? && @right.nil?
  end

  def to_s
    if leaf?
      val
    elsif unary?
      "( #{val} #{@left.to_s} )"
    else
      "( #{val} #{@left.to_s} #{@right.to_s} )"
    end
  end
end
