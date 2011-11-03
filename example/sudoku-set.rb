require File.dirname(__FILE__) + '/example_helper'
require 'enumerator'

# Solves the sudoku problem using sets. The model used is a fairly direct 
# translation of the corresponding Gecode example: 
# http://www.gecode.org/gecode-doc-latest/sudoku-set_8cc-source.html .
class SudokuSet
  include Gecode::Mixin

  # Takes a 9x9 matrix of values in the initial sudoku, 0 if the square is 
  # empty. 
  def initialize(predefined_values)
    # Verify that the input is of a valid size.
    @size = n = predefined_values.row_size
    block_size = Math.sqrt(n).round
    unless predefined_values.square? and block_size**2 == n
      raise ArgumentError, 'Incorrect value matrix size.'
    end
    sub_count = block_size
    
    # Create one set per assignable number (i.e. 1..9). Each set contains the 
    # position of all squares that the number is located in. The squares are 
    # given numbers from 1 to 81. Each set therefore has an empty lower bound 
    # (since we have no guarantees where a number will end up) and 1..81 as 
    # upper bound (as it may potentially occurr in any square). We know that
    # each assignable number must occurr 9 times in a solved sudoku, so we 
    # set the cardinality to 9..9 .
    sets_is_an set_var_array(n, [], 1..n*n, n..n)
    predefined_values.row_size.times do |i|
      predefined_values.column_size.times do |j|
        unless predefined_values[i,j].zero?
          # We add the constraint that the square position must occurr in the 
          # set corresponding to the predefined value.
          sets[predefined_values[i,j] - 1].must_be.superset_of [i*n + j+1]
        end
      end
    end

    # Build arrays containing the square positions of each row and column.
    rows = []
    columns = []
    n.times do |i|
      rows << ((i*n + 1)..(i*n + n))
      columns << (0...n).map{ |e| e*n + 1 + i }
    end
    
    # Build arrays containing the square positions of each block.
    blocks = []
    # The square numbers of the first block.
    first_block = (0...block_size).map do |e| 
      ((n*e+1)..(n*e+block_size)).to_a 
    end.flatten
    block_size.times do |i|
      block_size.times do |j| 
        blocks << first_block.map{ |e| e + (j*n*block_size)+(i*block_size) }
      end
    end

    # All sets must be pairwise disjoint since two numbers can't be assigned to
    # the same square.
    n.times do |i|
      (i + 1).upto(n - 1) do |j|
        sets[i].must_be.disjoint_with sets[j]
      end
    end

    # The sets must intersect in exactly one element with each row column and
    # block. I.e. an assignable number must be assigned exactly once in each
    # row, column and block. 
    sets.each do |set|
      rows.each do |row|
        set.intersection(row).size.must == 1
      end
      columns.each do |column|
        set.intersection(column).size.must == 1
      end
      blocks.each do |block|
        set.intersection(block).size.must == 1
      end
    end

    # Branching.
    branch_on sets, :variable => :none, :value => :min
  end
  
  # Outputs the assigned numbers in a grid.
  def to_s
    squares = []
    sets.values.each_with_index do |positions, i|
      positions.each{ |square_position| squares[square_position - 1] = i + 1 }
    end
    squares.enum_slice(@size).map{ |slice| slice.join(' ') }.join("\n")
  end
end

predefined_squares = Matrix[
  [0,0,0, 2,0,5, 0,0,0],
  [0,9,0, 0,0,0, 7,3,0],
  [0,0,2, 0,0,9, 0,6,0],
    
  [2,0,0, 0,0,0, 4,0,9],
  [0,0,0, 0,7,0, 0,0,0],
  [6,0,9, 0,0,0, 0,0,1],
      
  [0,8,0, 4,0,0, 1,0,0],
  [0,6,3, 0,0,0, 0,8,0],
  [0,0,0, 6,0,8, 0,0,0]]
puts SudokuSet.new(predefined_squares).solve!.to_s
