require './ast'
require './evaluator'

def assert_true val
  raise "Test failed with val: #{val}" unless val
  puts "Success: #{val}"
end

expr1 = "( ^ ( ! A ) B )"
tree1 = AST.new(expr1.split)
eval1 = Evaluator.new(expr1, { "A" => true, "B" => false })
eval1_2 = Evaluator.new(expr1, { "A" => false, "B" => true })
expr2 = "A"
tree2 = AST.new(expr2.split)
expr3 = "( -> ( ^ A B ) ( v C ( ! B ) ) )"
tree3 = AST.new(expr3.split)
expr4 = "( -> A B )"
tree4 = AST.new(expr4.split)
eval4_1 = Evaluator.new(expr4, { "A" => true, "B" => true })
eval4_2 = Evaluator.new(expr4, { "A" => true, "B" => false })
eval4_3 = Evaluator.new(expr4, { "A" => false, "B" => true })
eval4_4 = Evaluator.new(expr4, { "A" => false, "B" => false })

# Tree 1
assert_true(tree1.root.val == "^")
assert_true(tree1.root.left.val == "!")
assert_true(tree1.root.left.left.val == "A")
assert_true(tree1.root.right.val == "B")
assert_true(tree1.to_s == expr1)
assert_true(eval1.eval == false)
assert_true(eval1_2.eval == true)

# Tree 2
assert_true(tree2.root.val == "A")
assert_true(tree2.root.left.nil?)
assert_true(tree2.root.right.nil?)
assert_true(tree2.to_s == expr2)

# Tree 3
assert_true(tree3.root.val == "->")
assert_true(tree3.root.left.val == "^")
assert_true(tree3.root.left.left.val == "A")
assert_true(tree3.root.left.right.val == "B")
assert_true(tree3.root.right.val == "v")
assert_true(tree3.root.right.left.val == "C")
assert_true(tree3.root.right.right.val == "!")
assert_true(tree3.root.right.right.left.val == "B")
assert_true(tree3.root.right.right.right.nil?)
assert_true(tree3.to_s == expr3)

# Tree 4
assert_true(tree4.simplify.to_s == "( v ( ! A ) B )")
assert_true(eval4_1.eval == true)
assert_true(eval4_2.eval == false)
assert_true(eval4_3.eval == true)
assert_true(eval4_4.eval == true)
