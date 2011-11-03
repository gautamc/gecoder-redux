require 'matrix'

module Gecode::Util #:nodoc:
  # Methods that make a matrix an enumerable.
  module MatrixEnumMethods #:nodoc:
    include Enumerable
  
    # Iterates over every element in the matrix.
    def each(&block)
      row_size.times do |i|
        column_size.times do |j|
          yield self[i,j]
        end
      end
    end
  end

  # Extends Matrix so that it's an enumerable.
  class EnumMatrix < Matrix #:nodoc:
    include MatrixEnumMethods
    
    def row(i)
      wrap_if_wrapped make_vector_enumerable(super)
    end
    
    def column(i)
      wrap_if_wrapped make_vector_enumerable(super)
    end
    
    def minor(*args)
      matrix = super
      class <<matrix
        include MatrixEnumMethods
      end
      return wrap_if_wrapped(matrix)
    end
    
    private
    
    # Makes the specified vector enumerable.
    def make_vector_enumerable(vector)
      class <<vector
        include Enumerable
  
        # Iterates over every element in the matrix.
        def each(&block)
          size.times do |i|
            yield self[i]
          end
        end
      end
      return vector
    end
    
    # Wraps the specified enumerable if the matrix itself is already wrapped.
    def wrap_if_wrapped(enum)
      if respond_to? :model
        model.wrap_enum(enum)
      else
        enum
      end
    end
  end
end
