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
          a = expr[2]
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
end