require File.dirname(__FILE__) + '/example_helper'

# Solves the cryptarithmetic send+most=money problem while maximizing the value
# of "money".
class SendMostMoney
  include Gecode::Mixin

  attr :money

  def initialize
    # Set up the variables, 9 letters with domain 0..9.
    s,e,n,d,m,o,s,t,y = letters_is_an int_var_array(9, 0..9)
    # Express the quantity we are optimizing, in this case money.
    # This utilises that any operand can be converted into a variable.
    @money = equation_row(m,o,n,e,y).to_int_var
    
    # Set up the constraints.
    # The equation must hold.
    (equation_row(s, e, n, d) + equation_row(m, o, s, t)).must == 
      equation_row(m, o, n, e, y) 
    
    # The initial letters may not be 0.
    s.must_not == 0
    m.must_not == 0
    
    # All letters must be assigned different digits.
    letters.must_be.distinct

    # Set the branching.
    branch_on letters, :variable => :smallest_size, :value => :min
  end

  private

  # A helper to make the linear equation a bit tidier. Takes a number of
  # variables and computes the linear combination as if the variable
  # were digits in a base 10 number. E.g. x,y,z becomes
  # 100*x + 10*y + z .
  def equation_row(*variables)
    variables.inject{ |result, variable| variable + result * 10 }
  end
end

solution = SendMostMoney.new.maximize! :money
puts 's e n d m o s t y'
puts solution.letters.values.join(' ')
puts "money: #{solution.money.value}"
