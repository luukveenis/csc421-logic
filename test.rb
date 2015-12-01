require './parse_tree'

def assert_true val
  raise "Test failed with val: #{val}" unless val
  puts "Success: #{val}"
end

expr1 = "( ^ ( ! A ) B )"
tree1 = ParseTree.new(expr1.split)
expr2 = "A"
tree2 = ParseTree.new(expr2.split)
expr3 = "( -> ( ^ A B ) ( v C ( ! B ) ) )"
tree3 = ParseTree.new(expr3.split)

# Tree 1
assert_true(tree1.root.val == "^")
assert_true(tree1.root.left.val == "!")
assert_true(tree1.root.left.left.val == "A")
assert_true(tree1.root.right.val == "B")
assert_true(tree1.to_s == expr1)

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
