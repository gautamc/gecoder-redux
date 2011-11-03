module Gecode
  module Mixin
    # Specifies an integer regexp that matches +regexp+ repeated between
    # +at_least+ and +at_most+ times (inclusive). If +at_most+ is
    # omitted then no upper bound is placed. If both +at_least+ and
    # +at_most+ are omitted then no bounds are placed.
    #
    # See IntEnum::Extensional::RegexpConstraint for the
    # allowed syntax of +regexp+.
    def repeat(regexp, at_least = nil, at_most = nil)
      unless at_least.nil? or at_least.kind_of? Fixnum
        raise TypeError, 
          "Expected the at_least argument to be a Fixnum, got #{at_least.class}"
      end
      unless at_most.nil? or at_most.kind_of?(Fixnum)
        raise TypeError, 
          "Expected the at_most argument to be a Fixnum, got #{at_most.class}"
      end

      reg = Util::Extensional.parse_regexp regexp
      if at_most.nil?
        if at_least.nil?
          reg.send '*'
        else
          reg.send('()', at_least)
        end
      else
        reg.send('()', at_least, at_most)
      end
    end

    # Matches +regexp+ repeated zero or one time (i.e. like '?' in normal 
    # regexps). Produces the same result as calling 
    #   
    #   repeat(regexp, 0, 1)
    def at_most_once(regexp)
      repeat(regexp, 0, 1)
    end
    
    # Matches +regexp+ repeated at least one time (i.e. like '+' in normal 
    # regexps). Produces the same result as calling 
    #   
    #   repeat(regexp, 1)
    def at_least_once(regexp)
      repeat(regexp, 1)
    end

    # Matches any of the specified +regexps+.
    def any(*regexps)
      regexps.inject(Gecode::Raw::REG.new) do |result, regexp|
        result | Util::Extensional.parse_regexp(regexp)
      end
    end
  end

  module Util::Extensional
    module_function

    # Parses a regular expression over the integer domain, returning
    # an instance of Gecode::REG .
    #
    # Pseudo-BNF of the integer regexp representation:
    # regexp ::= <Fixnum> | <TrueClass> | <FalseClass> | <Gecode::Raw::REG> 
    #          | [<regexp>, ...]
    def parse_regexp(regexp)
      # Check the involved types.
      unless regexp.kind_of? Enumerable
        regexp = [regexp]
      end
      regexp.to_a.flatten.each do |element|
        unless element.kind_of?(Fixnum) or element.kind_of?(Gecode::Raw::REG) or
            element.kind_of?(TrueClass) or element.kind_of?(FalseClass)
          raise TypeError, 
            "Can't translate #{element.class} into integer or boolean regexp."
        end
      end

      # Convert it into a regexp.
      internal_parse_regexp(regexp)
    end

    private

    # Recursively converts arg into an instance of Gecode::REG. It is
    # assumed that arg is of kind Gecode::Raw::REG, Fixnum, TrueClass,
    # FalseClass or Enumerable.
    def self.internal_parse_regexp(arg)
      case arg 
        when Gecode::Raw::REG
          arg
        when Fixnum
          Gecode::Raw::REG.new(arg)
        when TrueClass
          Gecode::Raw::REG.new(1)
        when FalseClass
          Gecode::Raw::REG.new(0)
        when Enumerable
          # Recursively convert the elements of the arg.
          arg.inject(Gecode::Raw::REG.new) do |regexp, element|
            regexp += internal_parse_regexp(element)
          end
      end
    end
  end
end
