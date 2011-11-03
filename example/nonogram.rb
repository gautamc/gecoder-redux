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
# Nonogram (a.k.a. Painting by Numbers) in Gecode/R
# 
# http://en.wikipedia.org/wiki/Nonogram
# """
# Nonograms or Paint by Numbers are picture logic puzzles in which cells
# in a grid have to be colored or left blank according to numbers given
# at the side of the grid to reveal a hidden picture. In this puzzle
# type, the numbers measure how many unbroken lines of filled-in squares
# there are in any given row or column. For example, a clue of "4 8 3"
# would mean there are sets of four, eight, and three filled squares, in
# that order, with at least one blank square between successive groups.
# """
#
# Also see
#   * Brunetti, Sara & Daurat, Alain (2003)
#     "An algorithm reconstructing convex lattice sets"
#     http://geodisi.u-strasbg.fr/~daurat/papiers/tomoqconv.pdf
#
#   * CSPLib problem 12 at http://www.csplib.org/
#
#   * http://www.puzzlemuseum.com/nonogram.htm
#
#   * Haskell solution:
#     http://twan.home.fmf.nl/blog/haskell/Nonograms.details
#
#   * My MiniZinc model http://www.hakank.org/minizinc/nonogram.mzn
#
#
# Model created by Hakan Kjellerstrand, hakank@bonetmail.com
# See also my Gecode/R page: http://www.hakank.org/gecode_r
#
# Slight modifications made by Andreas Launila to keep the example in
# line with the other example models.
class Nonogram 
  include Gecode::Mixin

  def initialize(row_rules, col_rules)
    # A matrix of variables where each variable represents whether the 
    # square has been filled in or not.
    filled_is_an bool_var_matrix(row_rules.size, col_rules.size)

    # Place the constraints on the rows.
    row_rules.each_with_index do |row_rule, i| 
      filled.row(i).must.match parse_regex(row_rule)
    end
    # Place the constraints on the columns.
    col_rules.each_with_index do |col_rule, i|
      filled.column(i).must.match parse_regex(col_rule)
    end

    branch_on filled, :variable => :none, :value => :max
  end

  # Parses a nonogram segment and converts it to a "regexp"
  # e.g. [3,2] -> [repeat(false), repeat(true,3,3), at_least_once(false),
  #                repeat(true,2,2),repeat(false)]
  def parse_regex(a)
    r = [repeat(false)]
    a.each_with_index do |e,i| 
      r << repeat(true,e,e)
      if i < a.length-1 then
        r << at_least_once(false) 
      end
    end
    r << repeat(false)
    return r
  end
end

# A nonogram problem taken from Wikipedia 
# http://en.wikipedia.org/wiki/Nonogram
# Animation:
# http://en.wikipedia.org/wiki/File:Paint_by_numbers_Animation.gif
#
row_rules = 
[
  [3],
  [5],
  [3,1],
  [2,1],
  [3,3,4],
  [2,2,7],
  [6,1,1],
  [4,2,2],
  [1,1],
  [3,1],
  [6],
  [2,7],
  [6,3,1],
  [1,2,2,1,1],
  [4,1,1,3],
  [4,2,2],
  [3,3,1],
  [3,3],
  [3],
  [2,1]
]
  
col_rules = 
 [
  [2],
  [1,2],
  [2,3],
  [2,3],
  [3,1,1],
  [2,1,1],
  [1,1,1,2,2],
  [1,1,3,1,3],
  [2,6,4],
  [3,3,9,1],
  [5,3,2],
  [3,1,2,2],
  [2,1,7],
  [3,3,2],
  [2,4],
  [2,1,2],
  [2,2,1],
  [2,2],
  [1],
  [1]
]

nonogram = Nonogram.new(row_rules, col_rules)
# Find all of the solutions.
num_solutions = 0
nonogram.each_solution do |s| 
  num_solutions += 1
  puts "\nSolution ##{num_solutions}\n"
  # Output the solution.
  s.filled.values.enum_slice(s.filled.column_size).each do |row|
    puts row.map{ |filled| filled ? "#" : " " }.join
  end
end

puts "\nNumber of solutions: #{num_solutions}"
