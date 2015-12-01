require './ast'

class Evaluator
  def initialize formula, assignment
    @formula = formula
    @assignment = assignment
  end

  def eval
    tree = AST.new(@formula.split).simplify
    tree.eval(@assignment)
  end
end
