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

#
# Minesweeper in Gecode/R
#
# From gecode/examples/minesweeper.cc:
# """
# A specification is a square matrix of characters. Alphanumeric 
# characters represent the number of mines adjacent to that field. 
# Dots represent fields with an unknown number of mines adjacent to 
# it (or an actual mine).
# """
# 
# E.g.
#      "..2.3."
#      "2....."
#      "..24.3"
#      "1.34.."
#      ".....3"
#      ".3.3.."
# """
# 
# Also see 
#  
# http://www.janko.at/Raetsel/Minesweeper/index.htm
#
# http://en.wikipedia.org/wiki/Minesweeper_(computer_game)
#
# Ian Stewart on Minesweeper: http://www.claymath.org/Popular_Lectures/Minesweeper/
#
# Richard Kaye's Minesweeper Pages
# http://web.mat.bham.ac.uk/R.W.Kaye/minesw/minesw.htm
# Some Minesweeper Configurations
# http://web.mat.bham.ac.uk/R.W.Kaye/minesw/minesw.pdf
#
# Compare with my other Minesweeper models:
#
# - MiniZinc: http://www.hakank.org/minizinc/minesweeper.mzn
#
# - Choco: http://www.hakank.org/choco/MineSweeper.java
#
# - JaCoP: http://www.hakank.org/JaCoP/MineSweeper.java
#
#
# Model created by Hakan Kjellerstrand, hakank@bonetmail.com
# See also my Gecode/R page: http://www.hakank.org/gecode_r
#
# Slight modifications made by Andreas Launila to keep the example in
# line with the other example models.
class Minesweeper
  include Gecode::Mixin

  # The provided +game+ should be a matrix encoding the problem in the
  # following way:
  #   -1 for the unknowns, 
  #  >= 0 for number of mines in the neighbourhood
  def initialize(game)
    # Boolean variables representing whether each square has a mine or
    # not.
    mines_is_an bool_var_matrix(game.row_size, game.column_size)

    # Place the constraints.
    game.row_size.times do |i|
      game.column_size.times do |j|
        # The sum of all the number of mines in the neighbourhood of this cell
        # must agree with the problem specification.
        if game[i,j] >= 0 then
          neighbourhood = mines.minor([i-1,0].max..(i+1), [j-1,0].max..(j+1))
          neighbourhood.to_a.flatten.sum.must == game[i,j]
        end

        # A square can not contain a mine if the number of neighbouring
        # mines is known.
        if game[i,j] >= 0 then
          mines[i,j].must_be.false
        end
      end
    end

    branch_on mines, :variable => :largest_degree, :value => :max
  end
end

class Array
  # A helper for summing the contents of an array.
  def sum
    inject{ |sum, x| sum + x }
  end
end

# Problem from Gecode/examples/minesweeper.cc  problem 2
X = -1 # unknowns
game = Matrix[
  [1,X,X,2,X,2,X,2,X,X],
  [X,3,2,X,X,X,4,X,X,1],
  [X,X,X,1,3,X,X,X,4,X],
  [3,X,1,X,X,X,3,X,X,X],
  [X,2,1,X,1,X,X,3,X,2],
  [X,3,X,2,X,X,2,X,1,X],
  [2,X,X,3,2,X,X,2,X,X],
  [X,3,X,X,X,3,2,X,X,3],
  [X,X,3,X,3,3,X,X,X,X],
  [X,2,X,2,X,X,X,2,2,X]
]

minesweeper = Minesweeper.new(game)
# Find all of the solutions.
num_solutions = 0
minesweeper.each_solution do |s| 
  num_solutions += 1
  puts "\nSolution ##{num_solutions}\n";
  # Print the solution.
  s.mines.values.enum_slice(s.mines.column_size).each do |row|
    puts row.map{ |filled| filled ? "X " : ". " }.join
  end
end

puts "\nNumber of solutions: #{num_solutions}"

