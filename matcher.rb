class Matcher

  # Const is the constant corresponding to a ground term
  # Quant is the quantified formula
  def initialize const, quant
    @const = const
    @quant = quant
  end

  # Loves(Dog(Fred), Fred)
  # Loves(x, x)

  # Returns a hash of variable bindings if the two match
  # Returns nil otherwise
  def match
    constants = extract_constants
    variables = format_quant.map(&:to_sym).uniq

    # This does a number of things, but the end result assigns opts as an array
    # of hashes representing all possible variable assignments.
    opts = variables.
      product(constants).
      combination(variables.size).
      map(&:to_h).
      reject { |x| x.size < variables.size }.
      uniq

    # Pass each hash to the formatted string and see if it matches the
    # constant expression. If it does, return the valid assignment.
    opts.select { |o| (@quant % o) == @const }
  end

  private

  # Parses the constant expression and returns the list of constants
  def extract_constants
    # Match the inner comma-separated list of constants
    m = @const.match(/[A-Z][a-z]*\((.*)\)/)
    raise "Invalid expression" if m.nil?

    # Return the array of constants with whitespace removed
    m[1].split(",").map(&:strip)
  end

  # Formats the quantified expression and returns a list of the variables
  # it contains
  def format_quant
    # Match against the inner comma-separated list of variables
    m = @quant.match(/[A-Z][a-z]*\((.*)\)/)
    raise "Invalid expression" if m.nil?

    # Extract the variables as an array
    vars = m[1].split(",").map(&:strip)

    # Replace the quantified expression with a formatted string, where any
    # variable x is replaced with %{x}, allowing us to pass assignments to it.
    @quant = @quant.sub(m[1], vars.map { |v| "%{#{v}}" }.join(", "))

    # Return the list of variables
    vars
  end
end
