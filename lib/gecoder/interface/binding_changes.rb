# This file adds a small layer on top of the bindings.
module GecodeRaw #:nodoc: all
  class Space
    # Used by Gecode during BAB-search.
    def constrain(best_so_far_space)
      Gecode::Mixin.constrain(self, best_so_far_space)
    end
  end
end
