require 'yaml'
require './matcher'

# Creates a Matcher object, performs the match, and displays the results
def run expr
  result = Matcher.new(expr["const"], expr["quant"]).match

  puts "Match( #{expr["const"]}"
  puts "\t#{expr["quant"]} )"
  puts
  if result.empty?
    puts "No valid matches were found."
  else
    puts "Is true with:"
    result.each do |r|
      puts r.keys.map { |k| "#{k.to_s} = #{r[k]}" }.join(", ")
    end
  end
  puts; puts
end

data = YAML.load_file "part4_data.yml"
data.each { |d| run d }
