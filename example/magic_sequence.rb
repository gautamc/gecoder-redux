require File.dirname(__FILE__) + '/example_helper'

# Solves the magic sequence problem.
class MagicSequence
  include Gecode::Mixin

  # n is the length of the sequence.
  def initialize(n)
    # The i:th variable represents the value of the i:th element in the 
    # sequence.
    sequence_is_an int_var_array(n, 0...n)
    
    # The basic requirement to qualify as a magic sequence.
    n.times{ |i| sequence.count(i).must == sequence[i] }
  
    # The following are implied constraints. They do not affect which 
    # assignments are solutions, but they do help prune the search space 
    # quicker.
    
    # The sum must be n. This follows from that there are exactly n elements and
    # that the sum of all elements are the number of occurrences in total, i.e. 
    # the number of elements.
    sequence.sum.must == n
    
    # sum(seq[i] * (i-1)) must equal 0 because sum(seq[i]) = n as seen above
    # and sum(i*seq[i]) is just another way to compute sum(seq[i]). So we get 
    # sum(seq[i] * (i-1)) = sum(seq[i]) - sum(i*seq[i]) = n - n = 0
    sequence.zip((-1...n).to_a).map{ |element, c| element*c }.sum.must == 0
    
    branch_on sequence, :variable => :smallest_degree, :value => :split_max
  end
  
  def to_s
    sequence.values.join(', ')
  end
end

class Array
  # Sums all the elements in the array using #+ .
  def sum
    inject{ |sum, element| sum + element }
  end
end

puts MagicSequence.new(500).solve!.to_s
