require File.dirname(__FILE__) + '/example_helper'

# Solves the n-queens problem: http://en.wikipedia.org/wiki/Nqueens . No attempt
# to break the involved symmetries is made.
class NQueens
  include Gecode::Mixin

  def initialize(n)
    @size = n
  
    # The row number that the queen in the i:th column has. By using this as
    # our variables we already make sure that no two queens are in the same
    # column.
    queen_rows_is_an int_var_array(n, 0...n)
    
    # Set up the constraints
    # Queens must not be in the same diagonal (negative slope).
    queen_rows.must_be.distinct(:offsets => (0...n).to_a)
    # Queens must not be in the same diagonal (positive slope).
    queen_rows.must_be.distinct(:offsets => (0...n).to_a.reverse)
    # Queens must not be in the same row.
    queen_rows.must_be.distinct
    
    # Branching, we use first-fail heuristic.
    branch_on queen_rows, :variable => :smallest_size, :value => :min
  end
  
  # Displays the assignment as a chessboard with queens denoted by 'x'.
  def to_s
    rows = queen_rows.values
  
    separator = '+' << '-' * (3 * @size + (@size - 1)) << "+\n"
    res = (0...@size).inject(separator) do |s, i|
      (0...@size).inject(s + '|') do |s, j|
        s << " #{rows[j] == i ? 'x' : ' '} |"
      end << "\n" << separator
    end
  end
end

# Print the first solution. Note that there are 92 solutions, but only 12 
# are rotationally distinct. For any serious use one should place additional
# constraints to eliminate those symmetries.
puts NQueens.new((ARGV[0] || 8).to_i).solve!.to_s
