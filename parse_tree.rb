require './node'

# Class to represent a parse tree of the syntax designed for this assignment
class ParseTree
  attr_reader :root

  BINARY_OPS = ["^", "v", "->", "<->"]
  UNARY_OPS = ["!"]
  OPS = BINARY_OPS + UNARY_OPS

  # expr is an array of symbols representing the expression after it has
  # been broken up
  def initialize expr
    @root = parse(expr)
  end

  # Returns the tree with all implications removed
  def simplify
    remove_implications @root
    self
  end

  def eval assignment
    eval_node @root, assignment
  end

  # Converts the tree back into an expression using the syntax defined for
  # this assignment
  def to_s
    @root.to_s
  end

  private

  # Recursive parser to build parse tree
  def parse expr
    # If the expression is not a primitive, parse it recursivelt
    if expr[0] == "("
      op = expr[1]

      # Expansion for binary operators
      if BINARY_OPS.include?(op)
        a = nil; b = nil
        # Is the first operand another expression?
        if expr[2] == "("
          close = 2 + close_index(expr[3..-1])
          a = expr[2..close]
          b = expr[(close + 1)..-1]
        # First operand is a primitive
        else
          a = expr[2..2]
          b = expr[3..-2]
        end
        Node.new(op, parse(a), parse(b))

      # Expansion for unary operators
      elsif UNARY_OPS.include?(op)
        Node.new(op, parse(expr[2..-2]), nil)

      # Throw an error for invalid expressions
      else
        raise "Invalid expression"
      end
   # Create a simple node when the expression is a primitive
   else
      Node.new(expr[0], nil, nil)
    end
  end

  # Finds the index of the first closing parenthesis that would match with the
  # one preceding expr. This is to take into account the fact that more
  # parantheses may be opened after the preceding one.
  def close_index expr
    open = 0
    expr.each_with_index do |symbol, index|
      # increase count of open parantheses
      open += 1 if symbol == "("

      # Found a closing paranthesis
      if symbol == ")"
        # It's the one we want
        if open == 0
          return index + 1
        # It's closing one that was opened later
        else
          open -= 1 if symbol == ")"
        end
      end
    end
    raise "Malformed expression, no closing paranthese"
  end

  # Replace all implications and double implications with their conjunction
  # and disjunction counterparts
  def remove_implications node
    return if node.nil?

    if node.val == "->"
      node.val = "v"
      node.left = Node.new("!", node.left, nil)
    elsif node.val == "<->"
      node.val = "^"
      node.left = Node.new("->", node.left, node.right)
      node.right = Node.new("->", node.right, node.left)
    end
    remove_implications node.left
    remove_implications node.right
  end

  # Recursively evaluate the node given the provided variable assignments
  def eval_node node, assignment
    # If the node is a leaf simply look up the assignment
    if node.leaf?
      assignment[node.val]
    # If the node is unary, we know it's a not (!)
    # This is not very generalized, but it's valid for the syntax defined
    elsif node.unary?
      !eval_node(node.left, assignment)
    # The node is binary and we assume implications are removed
    else
      case node.val
      when "^"
        eval_node(node.left, assignment) && eval_node(node.right, assignment)
      when "v"
        eval_node(node.left, assignment) || eval_node(node.right, assignment)
      end
    end
  end
end
