require './parse_tree'

class Evaluator
  def initialize formula, assignment
    @formula = formula
    @assignment = assignment
  end

  def eval
    tree = ParseTree.new(@formula.split).simplify
    tree.eval(@assignment)
  end
end
