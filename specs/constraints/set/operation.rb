require File.dirname(__FILE__) + '/../property_helper'

Gecode::Util::SET_OPERATION_TYPES.each_pair do |operation, type|
  describe Gecode::Set::Operation, " (#{operation} with set variable)" do
    before do
      @model = Gecode::Model.new
      @set1 = @model.set_var([0], 0..20)
      @set2 = @model.set_var([1], 0..20)
      @constant_set = [2, 3, 5]
      @rhs = @model.set_var([], 0..20)
      @model.branch_on @model.wrap_enum([@set1, @set2, @rhs])
    
      @property_types = [:set, :set]
      @select_property = lambda do |set1, set2|
        set1.method(operation).call(set2)
      end
      @selected_property = @set1.method(operation).call(@set2)
      @constraint_class = 
        Gecode::Set::Operation::OperationConstraint
    end

    it "should translate #{operation} into an operation constraint" do
      @model.allow_space_access do
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), @set1.bind, type, @set2.bind, 
          Gecode::Raw::SRT_EQ, @rhs.bind)
      end
      @set1.method(operation).call(@set2).must == @rhs
      @model.solve!
    end

    it "should constrain the #{operation} of the sets with variable rhs" do
      @set1.method(operation).call(@set2).must == @rhs
      @model.solve!

      s1 = @set1.value.to_a
      s2 = @set2.value.to_a
      rhs = @rhs.value.to_a
      case operation
        when :union
          (s1 | s2).should == rhs
        when :disjoint_union
          (s1 | s2).sort.should == rhs.sort
        when :intersection
          (s1 & s2).should == rhs
        when :minus
          (s1 - s2).should == rhs
      end
    end

    it "should constrain the #{operation} of the sets when used with constant rhs" do
      if operation == :union || operation == :disjoint_union
        @constant_set << 0 << 1 # Or there will not be any solution.
      end
      @set1.method(operation).call(@set2).must == @constant_set
      @model.solve!

      s1 = @set1.value.to_a
      s2 = @set2.value.to_a
      rhs = @constant_set
      case operation
        when :union
          (s1 | s2).sort.should == rhs.sort
        when :disjoint_union
          (s1 | s2).sort.should == rhs.sort
        when :intersection
          (s1 & s2).should == rhs
        when :minus
          (s1 - s2).should == rhs
      end
    end
    
    it_should_behave_like(
      'property that produces set operand by short circuiting set relations')
  end
end

Gecode::Util::SET_OPERATION_TYPES.each_pair do |operation, type|
  describe Gecode::Set::Operation, " (#{operation} with constant set)" do
    before do
      @model = Gecode::Model.new
      @set = @model.set_var([0], 0..20)
      @constant_set = [1, 3, 5]
      @rhs = @model.set_var([], 0..20)
      @model.branch_on @model.wrap_enum([@set, @rhs])
    
      @property_types = [:set, :set]
      @select_property = lambda do |set1, set2|
        set1.method(operation).call(set2)
      end
      @selected_property = @set.method(operation).call(@constant_set)
      @constraint_class = 
        Gecode::Set::Operation::OperationConstraint
    end

    it "should translate #{operation} into an operation constraint" do
      @model.allow_space_access do
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), @set.bind, type, 
          an_instance_of(Gecode::Raw::IntSet),
          Gecode::Raw::SRT_EQ, @rhs.bind)
      end
      @set.method(operation).call(@constant_set).must == @rhs
      @model.solve!
    end

    it "should constrain the #{operation} of the sets with a variable rhs" do
      @set.method(operation).call(@constant_set).must == @rhs
      @model.solve!

      s1 = @set.value.to_a
      s2 = @constant_set
      rhs = @rhs.value.to_a
      case operation
        when :union
          (s1 | s2).should == rhs
        when :disjoint_union
          (s1 | s2).sort.should == rhs.sort
        when :intersection
          (s1 & s2).should == rhs
        when :minus
          (s1 - s2).should == rhs
      end
    end

    # We do not test with a constant rhs since we do not have enough
    # degrees of freedom to always find a solution.

    it_should_behave_like(
      'property that produces set operand by short circuiting set relations')
  end
end
