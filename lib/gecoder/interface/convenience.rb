module Gecode
  # A convenient class that just includes Gecode::Mixin. Can be useful
  # when you don't want to create your own class that mixes in
  # Gecode::Mixin.
  class Model
    include Gecode::Mixin
  end

  # Provides a convenient way to construct a model and then find a
  # solution. The model constructed uses the specified block as 
  # initialization method. The first solution to the model is then
  # returned.
  #
  # For instance
  #
  #   solution = Gecode.solve do
  #     # Do something
  #   end
  # 
  # is equivalent to
  # 
  #   class Foo 
  #     include Gecode::Mixin
  #
  #     def initialize
  #       # Do something
  #     end
  #   end
  #   solution = Foo.new.solve!
  def self.solve(&block)
    create_model(&block).solve!
  end

  # Provides a convenient way to construct a model and then find the
  # solution that maximizes a given variable. The model constructed 
  # uses the specified block as initialization method. The solution
  # that maximizes the specified variable is then returned.
  #
  # For instance
  #
  #   solution = Gecode.maximize :variable_bar do
  #     # Do something
  #   end
  # 
  # is equivalent to
  # 
  #   class Foo 
  #     include Gecode::Mixin
  #
  #     def initialize
  #       # Do something
  #     end
  #   end
  #   solution = Foo.new.maximize :variable_bar
  def self.maximize(variable_to_maximize, &block)
    create_model(&block).maximize! variable_to_maximize
  end

  # Provides a convenient way to construct a model and then find the
  # solution that minimizes a given variable. The model constructed 
  # uses the specified block as initialization method. The solution
  # that minimizes the specified variable is then returned.
  #
  # For instance
  #
  #   solution = Gecode.minimize :variable_bar do
  #     # Do something
  #   end
  # 
  # is equivalent to
  # 
  #   class Foo
  #     include Gecode::Mixin
  #
  #     def initialize
  #       # Do something
  #     end
  #   end
  #   solution = Foo.new.minimize :variable_bar
  def self.minimize(variable_to_minimize, &block)
    create_model(&block).minimize! variable_to_minimize
  end

  private

  # Creates an instance of a class that subclasses Model and uses the 
  # specified block as initialization method.
  def self.create_model(&block)
    model = Class.new
    model.class_eval do
      include Gecode::Mixin

      def initialize(&init_block) #:nodoc:
        instance_eval &init_block
      end
    end
    model.new(&block)
  end
end
