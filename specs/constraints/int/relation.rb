require File.dirname(__FILE__) + '/../constraint_helper'

Gecode::Util::RELATION_TYPES.each_pair do |relation, rel_value|
  describe Gecode::Int::Relation, " (#{relation} with int op)" do
    before do
      @model = Gecode::Model.new
      
      # For constraint spec.
      @types = [:int, :int]
      @invoke = lambda do |receiver, op, hash| 
        receiver.method(relation).call(op, hash) 
        @model.solve!
      end
      @expect = lambda do |var1, var2, opts, reif_var|
        if reif_var.nil?
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var1, rel_value, var2, *opts)
        else
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var1, rel_value, var2, reif_var, *opts)
        end
      end
    end
    
    it "should constrain the #{relation} with an int operand" do
      ints = @model.int_var_array(2, -5..5)
      @model.branch_on ints
      int1, int2 = ints
      int1.must.method(relation).call(int2)
      @model.solve!
      int1.value.should.method(relation).call(int2.value)
    end

    it "should constrain the negated #{relation} with an int operand" do
      ints = @model.int_var_array(2, -5..5)
      @model.branch_on ints
      int1, int2 = ints
      int1.must_not.method(relation).call(int2)
      @model.solve!
      int1.value.should_not.method(relation).call(int2.value)
    end

    it_should_behave_like 'reifiable constraint'
  end
end

Gecode::Util::RELATION_TYPES.each_pair do |relation, rel_value|
  describe Gecode::Int::Relation, " (#{relation} with fixnum)" do
    before do
      @model = Gecode::Model.new
      
      # For constraint spec.
      @types = [:int]
      @invoke = lambda do |receiver, hash| 
        receiver.method(relation).call(17, hash) 
        @model.solve!
      end
      @expect = lambda do |var, opts, reif_var|
        if reif_var.nil?
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var, rel_value, 17, *opts)
        else
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var, rel_value, 17, reif_var, *opts)
        end
      end
    end

    it "should constrain the #{relation} with a fixnum" do
      int = @model.int_var(-5..5)
      @model.branch_on int
      int.must.method(relation).call(3)
      @model.solve!
      int.value.should.method(relation).call(3)
    end
    
    it_should_behave_like 'reifiable constraint'
  end
end

