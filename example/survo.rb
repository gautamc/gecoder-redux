# Copyright 2009, Hakan Kjellerstrand <hakank@bonetmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

require File.dirname(__FILE__) + '/example_helper'
require 'enumerator'

# Survo Puzzle in Gecode/R
#
# http://en.wikipedia.org/wiki/Survo_Puzzle
# """
# Survo puzzle is a kind of logic puzzle presented (in April 2006) and studied 
# by Seppo Mustonen. The name of the puzzle is associated to Mustonen's 
# Survo system which is a general environment for statistical computing and 
# related areas.
# 
# In a Survo puzzle the task is to fill an m * n table by integers 1,2,...,m*n so 
# that each of these numbers appears only once and their row and column sums are 
# equal to integers given on the bottom and the right side of the table. 
# Often some of the integers are given readily in the table in order to 
# guarantee uniqueness of the solution and/or for making the task easier.
# """
# 
# See also
# http://www.survo.fi/english/index.html
# http://www.survo.fi/puzzles/index.html
#
# References:
# Mustonen, S. (2006b). "On certain cross sum puzzles", http://www.survo.fi/papers/puzzles.pdf 
# Mustonen, S. (2007b). "Enumeration of uniquely solvable open Survo puzzles.", http://www.survo.fi/papers/enum_survo_puzzles.pdf 
# Kimmo Vehkalahti: "Some comments on magic squares and Survo puzzles", http://www.helsinki.fi/~kvehkala/Kimmo_Vehkalahti_Windsor.pdf
# R code: http://koti.mbnet.fi/tuimala/tiedostot/survo.R
#
# Compare with my other Survo Puzzle models
#
# - MiniZinc: http://www.hakank.org/minizinc/survo_puzzle.mzn
# - JaCoP: http://www.hakank.org/JaCoP/SurvoPuzzle.java
# - Choco: http://www.hakank.org/choco/SurvoPuzzle.java
#
# Model created by Hakan Kjellerstrand, hakank@bonetmail.com
# See also my Gecode/R page: http://www.hakank.org/gecode_r
#
# Slight modifications made by Andreas Launila to keep the example in
# line with the other example models.
class SurvoPuzzle
  include Gecode::Mixin
  
  # The +clues+ are given as an m*n matrix where 0 represents that the
  # cell has no clue. The row sums and column sums are specified by the
  # +rowsums+ array of length m, and the +colsums+ array of length n
  # respectively.
  def initialize(clues, rowsums, colsums)
    r = rowsums.length # Number of rows 
    c = colsums.length # Number of columns

    # Integer variables representing each cell in the m*n table.
    cells_is_an int_var_matrix(r, c, 1..r*c)

    # Add the constraints.
    # Each number must appear only once.
    cells.must_be.distinct

    # The row sums must be satisfied.
    cells.row_vectors.each_with_index do |row, i| 
      row.sum.must == rowsums[i]
    end

    # The column sums must be satisfied.
    cells.column_vectors.each_with_index do |column, i| 
      column.sum.must == colsums[i] 
    end

    # The clues must be satisfied.
    cells.row_size.times do |i| 
      cells.column_size.times do |j|
        cells[i,j].must == clues[i,j] if clues[i,j] > 0
      end
    end

    branch_on cells, :variable => :smallest_size, :value => :min
  end
end

class Vector
  # A helper for summing the contents of a vector.
  def sum
    inject{ |sum, element| sum + element }
  end
end

# Default problem:
# Survo puzzle 126/2008 (25) #363-33148
# From http://www.survo.fi/puzzles/280708.txt
rowsums = [32,79,60]
colsums = [24,22,43,35,39,8]
clues = Matrix[
         [ 0, 4, 0, 0, 0, 0,32],
         [12, 0, 0,16,17, 0,79],
         [ 0, 0,15, 0, 0, 2,60],
        ]

survo_puzzle = SurvoPuzzle.new(clues, rowsums, colsums)
num_solutions = 0
survo_puzzle.each_solution do |s| 
  num_solutions += 1
  puts "\nSolution ##{num_solutions}";
  # Print the solution.
  s.cells.values.enum_slice(s.cells.column_size).each_with_index do |row,i|
    row.each{ |element| printf('%3d ', element) }
    printf ' = %3d ', rowsums[i]
    puts
  end
  colsums.size.times{ printf('%2s= ', '') }
  puts 
  colsums.each{ |element| printf('%3d ', element) }
end

puts "\nNumber of solutions: #{num_solutions}"

