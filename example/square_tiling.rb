require File.dirname(__FILE__) + '/example_helper'

# Solves the square tiling problem. The objective is to pack supplied squares 
# into a bigger rectangle so that there is no overlap.
class SquareTiling
  include Gecode::Mixin

  # Takes the width and height of the rectangle to pack the squares into. Then
  # the sizes of the squares that should be packed into the rectangle. The sizes
  # must be sorted.
  def initialize(width, height, square_sizes)
    @sizes = square_sizes
    @square_count = @sizes.size
    
    # The coordinates of the placed squares.
    @xs = int_var_array(@square_count, 0..(width - @sizes.min))
    @ys = int_var_array(@square_count, 0..(height - @sizes.min))
    
    # The essential constraints of the problem.
    @square_count.times do |i|
      # Each square must be placed within the bounds
      @xs[i].must <= width - @sizes[i]
      @ys[i].must <= height - @sizes[i]
      
      # Pairwise conditions, no pair of squares may overlap.
      0.upto(i - 1) do |j|
        # That the two squares don't overlap means that i is left of j, 
        # or j is left of i, or i is above j, or j is above i.
        ((@xs[j] - @xs[i]).must >= @sizes[i]) | 
          ((@xs[i] - @xs[j]).must >= @sizes[j]) | 
          ((@ys[j] - @ys[i]).must >= @sizes[i]) | 
          ((@ys[i] - @ys[j]).must >= @sizes[j])
      end
    end
    
    # A couple of implied constraints that only serve to make the solving 
    # faster:

    # The combined size of all squares occupying a column must be equal to the 
    # total height.
    occupied_length_must_equal_total_length(height, width, @xs)
    # The combined size of all squares occupying a row must be equal to the 
    # total width.
    occupied_length_must_equal_total_length(width, height, @ys)

    # Symmetry-breaking constraint: Order squares of the same size.
    @square_count.times do |i|
      @xs[i].must <= @xs[i+1] if @sizes[i] == @sizes[i+1]
    end

    # Place the squares left to right on the x-axis first, then the y-axis.
    branch_on @xs, :variable => :smallest_min, :value => :min
    branch_on @ys, :variable => :smallest_min, :value => :min
  end
  
  # Constrains the combined length of the squares in the same row or column to
  # equal +total_length+ in the axis of the specified coordinates +coords+, 
  # which is +axist_length+ long.
  def occupied_length_must_equal_total_length(total_length, axis_length, coords)
    axis_length.times do |i|
      # We create an array of boolean variables and constrain it so that element
      # +j+ is true iff square +j+ occupies +i+ (+i+ being a row or column).
      occupied = bool_var_array(@square_count)
      occupied.each_with_index do |is_occupying, j|
        coords[j].must_be.in((i - @sizes[j] + 1)..i, :reify => is_occupying)
      end
      
      # Constrain the combined length of squares that are occupying +i+ to equal
      # the total length. We multiply the sizes with the boolean variables 
      # since a boolean in linear equation is 0 if assigned false and 1 if 
      # assigned true. Hence we will mask out the sizes of any squares not in 
      # +i+.
      occupied_sizes = occupied.zip(@sizes).map{ |bool, size| bool*size }
      occupied_sizes.inject(0){ |sum, x| x + sum }.must.equal(total_length, 
        :strength => :domain)
    end
  end
  
  # Displays the coordinates of the squares.
  # TODO: Something more impressive. 
  def to_s
    @xs.values.zip(@ys.values).map{ |x,y| "(#{x}, #{y})"}.join(', ')
  end
end

puts SquareTiling.new(65, 47, [25, 24, 23, 22, 19, 17, 11, 6, 5, 3]).solve!.to_s
