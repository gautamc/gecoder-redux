require File.dirname(__FILE__) + '/example_helper'

# Solves the send+more=money problem: 
# http://en.wikipedia.org/wiki/Send%2Bmore%3Dmoney
solution = Gecode.solve do
  # A helper to make the linear equation a bit tidier. Takes a number of
  # variables and computes the linear combination as if the variable
  # were digits in a base 10 number. E.g. x,y,z becomes
  # 100*x + 10*y + z .
  def equation_row(*variables)
    variables.inject{ |result, variable| variable + result*10 }
  end

  # Set up the variables. 
  # Let "letters" be an array of 8 integer variables with domain 0..9.
  # The elements represents the letters s, e, n, d, m, o, r and y.
  letters_is_an int_var_array(8, 0..9)
  s,e,n,d,m,o,r,y = letters

  # Set up the constraints.
  # The equation must hold.
  (equation_row(s, e, n, d) + equation_row(m, o, r, e)).must ==
    equation_row(m, o, n, e, y)

  # The initial letters may not be 0.
  s.must_not == 0
  m.must_not == 0

  # All letters must be assigned different digits.
  letters.must_be.distinct

  # Tell Gecode what variables we want to know the values of.
  branch_on letters, :variable => :smallest_size, :value => :min
end

puts 's e n d m o r y'
puts solution.letters.values.join(' ')
