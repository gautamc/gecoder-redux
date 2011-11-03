require File.dirname(__FILE__) + '/../constraint_helper'

Gecode::Util::RELATION_TYPES.each_pair do |relation, rel_value|
  describe Gecode::SetElements::Relation, " (#{relation} with int op)" do
    before do
      @model = Gecode::Model.new
      @set = @model.set_var([0], 0..2)
      @int = @model.int_var(-1..2)
      @model.branch_on @set
      @model.branch_on @int

      # For constraint spec.
      @types = [:set_elements, :int]
      @invoke = lambda do |receiver, op, hash| 
        receiver.method(relation).call(op, hash) 
        @model.solve!
      end
      @expect = lambda do |var1, var2, opts, reif_var|
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var1, rel_value, var2)
      end
    end

    it "should constrain the elements of the set when #{relation} is used" do
      @set.elements.must.method(relation).call(@int)
      @model.solve!
      @set.value.each do |i|
        i.should.method(relation).call(@int.value)
      end
    end

    it "should constrain the elements of the set when negated #{relation} is used" do
      @set.elements.must_not.method(relation).call(@int)
      @model.solve!
      @set.value.each do |i|
        i.should_not.method(relation).call(@int.value)
      end
    end

    it_should_behave_like 'non-reifiable set constraint'
  end
end

Gecode::Util::RELATION_TYPES.each_pair do |relation, rel_value|
  describe Gecode::SetElements::Relation, " (#{relation} with fixnum)" do
    before do
      @model = Gecode::Model.new
      @set = @model.set_var([], 0..2)
      @int_constant = 1
      @model.branch_on @set

      # For constraint spec.
      @types = [:set_elements]
      @invoke = lambda do |receiver, hash| 
        receiver.method(relation).call(@int_constant, hash) 
        @model.solve!
      end
      @expect = lambda do |var1, var2, opts, reif_var|
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var1, rel_value, an_instance_of(Gecode::Raw::IntVar))
      end
    end

    it "should constrain the elements of the set when #{relation} is used" do
      @set.elements.must.method(relation).call(@int_constant)
      @model.solve!
      @set.value.each do |i|
        i.should.method(relation).call(@int_constant)
      end
    end

    it "should constrain the elements of the set when negated #{relation} is used" do
      @set.elements.must_not.method(relation).call(@int_constant)
      @model.solve!
      @set.value.each do |i|
        i.should_not.method(relation).call(@int_constant)
      end
    end

    it_should_behave_like 'non-reifiable set constraint'
  end
end
