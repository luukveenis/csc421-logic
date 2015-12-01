require 'yaml'
require './evaluator'

data = YAML.load_file "part2_data.yml"

# Iterate over all the provided assignments and evaluate E
data["assignments"].each do |name, assignment|
  a = Evaluator.new(data["formulas"]["A"], assignment).eval
  b = Evaluator.new(data["formulas"]["B"], assignment).eval
  c = Evaluator.new(data["formulas"]["C"], assignment).eval
  d = Evaluator.new(data["formulas"]["D"], assignment).eval

  # Create the assignment to pass to E
  new_assignment = {
    "A" => a,
    "B" => b,
    "C" => c,
    "D" => d
  }

  # Evaluate E
  e = Evaluator.new(data["formulas"]["E"], new_assignment).eval

  puts "Expressions E evaluated under #{name} is: #{e}"
end
