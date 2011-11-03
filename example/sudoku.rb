require File.dirname(__FILE__) + '/example_helper'
require 'enumerator'

# Solves the sudoku problem: http://en.wikipedia.org/wiki/Soduko

# The sudoku we want to solve (0 represents that the square is empty).
sudoku = Matrix[
  [0,0,0, 2,0,5, 0,0,0],
  [0,9,0, 0,0,0, 7,3,0],
  [0,0,2, 0,0,9, 0,6,0],
    
  [2,0,0, 0,0,0, 4,0,9],
  [0,0,0, 0,7,0, 0,0,0],
  [6,0,9, 0,0,0, 0,0,1],
      
  [0,8,0, 4,0,0, 1,0,0],
  [0,6,3, 0,0,0, 0,8,0],
  [0,0,0, 6,0,8, 0,0,0]]

solution = Gecode.solve do
  # Verify that the input is of a valid size.
  n = sudoku.row_size
  sub_matrix_size = Math.sqrt(n).round
  unless sudoku.square? and sub_matrix_size**2 == n
    raise ArgumentError, 'Incorrect value matrix size.'
  end
  sub_count = sub_matrix_size
    
  # Create the squares and initialize them.
  squares_is_an int_var_matrix(n, n, 1..n)
  sudoku.row_size.times do |i|
    sudoku.column_size.times do |j|
      squares[i,j].must == sudoku[i,j] unless sudoku[i,j] == 0
    end
  end
  
  # Constraints.
  n.times do |i|
    # All rows must contain distinct numbers.
    squares.row(i).must_be.distinct(:strength => :domain)
    # All columns must contain distinct numbers.
    squares.column(i).must_be.distinct(:strength => :domain)
    # All sub-matrices must contain distinct numbers.
    squares.minor(
      (i % sub_count) * sub_matrix_size, 
      sub_matrix_size, 
      (i / sub_count) * sub_matrix_size, 
      sub_matrix_size).must_be.distinct(:strength => :domain)
  end
  
  # Branching, we use first-fail heuristic.
  branch_on squares, :variable => :smallest_size, :value => :min
end.squares.values

# Output the solved sudoku in a grid.
puts solution.enum_slice(sudoku.row_size).map{ |slice| slice.join(' ') }.join($/)
