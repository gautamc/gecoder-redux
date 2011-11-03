require File.dirname(__FILE__) + '/../property_helper'

Gecode::Util::SET_OPERATION_TYPES.each_pair do |operation, type|
  describe Gecode::FixnumEnum::Operation, " (#{operation} with set variable)" do
    before do
      @model = Gecode::Model.new
      @constant_lhs = @model.wrap_enum [0, 4, 7]
      @set = @model.set_var([1], 0..20)
      @constant_set = [2, 3, 5]
      @rhs = @model.set_var([], 0..20)
      @model.branch_on @model.wrap_enum([@set, @rhs])
    
      @property_types = [:fixnum_enum, :set]
      @select_property = lambda do |fixnum_enum, set|
        fixnum_enum.method(operation).call(set)
      end
      @selected_property = @constant_lhs.method(operation).call(@set)
      @constraint_class = 
        Gecode::Set::Operation::OperationConstraint
    end

    it "should translate #{operation} into an operation constraint" do
      @model.allow_space_access do
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), 
          an_instance_of(Gecode::Raw::IntSet), type, @set.bind, 
          Gecode::Raw::SRT_EQ, @rhs.bind)
      end
      @constant_lhs.method(operation).call(@set).must == @rhs
      @model.solve!
    end

    it "should constrain the #{operation} of the sets with variable rhs" do
      @constant_lhs.method(operation).call(@set).must == @rhs
      @model.solve!

      s1 = @constant_lhs
      s2 = @set.value.to_a
      rhs = @rhs.value.to_a
      case operation
        when :union
          (s1 | s2).sort.should == rhs.sort
        when :disjoint_union
          (s1 | s2 - (s1 & s2)).sort.should == rhs.sort
        when :intersection
          (s1 & s2).should == rhs
        when :minus
          (s1 - s2).should == rhs
      end
    end

    it 'should not allow constant sets to be given as argument' do
      lambda do
        @constant_lhs.method(operation).call(@constant_set).must == @rhs
      end.should raise_error(TypeError)
    end

    it 'should not allow all three parameters to be constant sets' do
      lambda do
        @constant_lhs.method(operation).call(@constant_set).must == [0]
      end.should raise_error(TypeError)
    end

    it_should_behave_like(
      'property that produces set operand by short circuiting set relations')
  end
end
