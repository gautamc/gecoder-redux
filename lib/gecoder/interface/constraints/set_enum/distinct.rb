module Gecode::SetEnum
  class SetEnumConstraintReceiver
    # Constrains all pairs of set operands in the enumeration to at
    # most have one element in common and be of a specified size.
    # Providing a size is not optional.
    # 
    # Neither negation nor reification is supported.
    # 
    # ==== Examples 
    # 
    #   # All set operands in +sets+ must have cardinality 17 and no pair may
    #   # have more than one element in common.
    #   sets.must.at_most_share_one_element(:size => 17)
    def at_most_share_one_element(options = {})
      unless options.has_key? :size
        raise ArgumentError, 'Option :size has to be specified.'
      end
      # TODO can we use Set::Util::decode_options here instead?
      unless options.size == 1
        raise ArgumentError, 'Only the option :size is accepted, got ' + 
          "#{options.keys.join(', ')}."
      end
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated atmost one ' + 
          'constrain is not implemented.'
      end
      
      @model.add_constraint Distinct::AtMostOneConstraint.new(
        @model, @params.update(options))
    end
  end
  
  # A module that gathers the classes and modules used in distinct constraints.
  module Distinct #:nodoc:
    class AtMostOneConstraint < Gecode::Constraint #:nodoc:
      def post
        sets, size = @params.values_at(:lhs, :size)
        Gecode::Raw::atmostOne(@model.active_space, 
          sets.to_set_enum.bind_array, size)
      end
    end
  end
end
