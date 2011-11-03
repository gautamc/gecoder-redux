require File.dirname(__FILE__) + '/../constraint_helper'

class BoolSampleProblem
  include Gecode::Mixin

  attr :b1
  attr :b2
  attr :b3
  
  def initialize
    @b1 = self.bool_var
    @b2 = self.bool_var
    @b3 = self.bool_var
  end
end

[:true, :false].each do |type|
  describe Gecode::Bool, " (must be #{type})" do
    before do
      @model = Gecode::Model.new
      @bool = @model.bool_var

      @types = [:bool]
      @invoke = lambda do |receiver, hash| 
        receiver.method(type).call(hash) 
        @model.solve!
      end
      @expect = lambda do |var, opts, reif_var|
        # We only test the non-MiniModel parts.
        unless reif_var.nil?
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            an_instance_of(Gecode::Raw::BoolVar), 
            (type == :true) ? Gecode::Raw::IRT_EQ : Gecode::Raw::IRT_NQ,
            reif_var, *opts)
        end
      end
    end

    it "should constrain variables to be #{type}" do
      @bool.must.method(type).call
      @model.solve!
      @bool.value.should == (type == :true)
    end
    
    it "should make negation constrain variables to not be #{type}" do
      @bool.must_not.method(type).call
      @model.solve!
      @bool.value.should == (type != :true)
    end  

    it_should_behave_like 'reifiable constraint'
  end
end

describe Gecode::Bool, " (implies)" do
  before do
    @model = Gecode::Model.new
    @b1 = @model.bool_var
    @b2 = @model.bool_var
    @model.branch_on @model.wrap_enum([@b1, @b2])

    @types = [:bool, :bool]
    @invoke = lambda do |receiver, op, hash| 
      receiver.imply(op, hash) 
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
    end
  end

  it "should constrain variables to imply each other" do
    @b1.must.imply @b2
    @model.solve!
    (!@b1.value || @b2.value).should be_true
  end
  
  it "should, when negated, constrain variables to not imply each other" do
    @b1.must_not.imply @b2
    @model.solve!
    @b1.value.should be_true
    @b2.value.should_not be_true
  end  

  it_should_behave_like 'reifiable constraint'
end

describe Gecode::Bool, " (equality)" do
  before do
    @model = Gecode::Model.new
    @b1 = @model.bool_var
    @b2 = @model.bool_var
    @model.branch_on @model.wrap_enum([@b1, @b2])

    @types = [:bool, :bool]
    @invoke = lambda do |receiver, op, hash| 
      receiver.equal(op, hash) 
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
    end
  end

  it "should constrain variables to equal each other" do
    @b1.must == @b2
    @model.solve!
    @b1.value.should == @b2.value
  end
  
  it "should, when negated, constrain variables to not equal each other" do
    @b1.must_not == @b2
    @model.solve!
    @b1.value.should_not == @b2.value
  end  

  it_should_behave_like 'reifiable constraint'
end

describe Gecode::Bool do
  before do
    @model = BoolSampleProblem.new
    @b1 = @model.b1
    @b2 = @model.b2
    @b3 = @model.b3
  end

  it 'should handle single variables constrainted to be true' do
    @b1.must_be.true
    b1 = @model.solve!.b1
    b1.should be_assigned
    b1.value.should be_true
  end
  
  it 'should handle single variables constrainted to be false' do
    @b1.must_be.false
    b1 = @model.solve!.b1
    b1.should be_assigned
    b1.value.should_not be_true
  end
  
  it 'should handle single variables constrainted not to be false' do
    @b1.must_not_be.false
    b1 = @model.solve!.b1
    b1.should be_assigned
    b1.value.should be_true
  end
  
  it 'should handle single variables constrainted not to be true' do
    @b1.must_not_be.true
    b1 = @model.solve!.b1
    b1.should be_assigned
    b1.value.should_not be_true
  end

  it 'should handle disjunction' do
    @b1.must_be.false
    (@b1 | @b2).must_be.true
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should be_true
  end

  it 'should handle negated disjunction' do
    @b1.must_be.false
    (@b1 | @b2).must_not_be.true
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should_not be_true
  end

  it 'should handle conjunction' do
    (@b1 & @b2).must_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should be_true
  end

  it 'should handle negated conjunction' do
    @b1.must_be.true
    (@b1 & @b2).must_not_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
  end

  it 'should handle exclusive or' do
    @b1.must_be.false
    (@b1 ^ @b2).must_be.true
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should be_true
  end

  it 'should handle negated exclusive or' do
    @b1.must_be.true
    (@b1 ^ @b2).must_not_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should be_true
  end
  
  it 'should handle implication' do
    @b2.must_be.false
    (@b1.implies @b2).must_be.true
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should_not be_true
  end
  
  it 'should handle negated implication' do
    @b1.must_be.true
    ((@b1 | @b2).implies @b2).must_not_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
  end
  
  it 'should handle imply after must' do
    @b2.must_be.false
    @b1.must.imply @b2
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should_not be_true
  end

  it 'should handle imply after must_not' do
    @b1.must_be.true
    @b1.must_not.imply @b2
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
  end

  it 'should handle single variables as right hand side' do
    @b1.must == @b2
    @b2.must_be.false
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b2.value.should_not be_true
  end
  
  it 'should handle single variables with negation as right hand side' do
    @b1.must_not == @b2
    @b2.must_be.false
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
  end

  it 'should handle expressions as right hand side' do
    @b1.must == (@b2 | @b3)
    @b2.must_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should be_true
  end

  it 'should handle nested expressions as left hand side' do
    ((@b1 & @b2) | @b3 | (@b1 & @b3)).must_be.true
    @b1.must_be.false
    sol = @model.solve!
    sol.b1.value.should_not be_true
    sol.b3.value.should be_true
  end

  it 'should handle nested expressions on both side' do
    ((@b1 & @b1) | @b3).must == ((@b1 & @b3) & @b2)
    @b1.must_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should be_true
    sol.b3.value.should be_true
  end

  it 'should handle nested expressions with implication' do
    ((@b1 & @b1) | @b3).must.imply(@b1 ^ @b2)
    @b1.must_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should be_false
  end

  it 'should handle nested expressions containing exclusive or' do
    ((@b1 ^ @b1) & @b3).must == ((@b2 | @b3) ^ @b2)
    @b1.must_be.true
    @b2.must_be.false
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
    sol.b3.value.should_not be_true
  end

  it 'should handle nested expressions on both sides with negation' do
    ((@b1 & @b1) | @b3).must_not == ((@b1 | @b3) & @b2)
    @b1.must_be.true
    @b3.must_be.true
    sol = @model.solve!
    sol.b1.value.should be_true
    sol.b2.value.should_not be_true
    sol.b3.value.should be_true
  end

  it 'should translate reification with a variable right hand side' do
    @b1.must_be.equal_to(@b2, :reify => @b3)
    @b1.must_be.true
    @b2.must_be.false
    sol = @model.solve!
    sol.b3.value.should_not be_true
  end

  it 'should translate reification with a variable right hand side and negation'  do
    @b1.must_not_be.equal_to(@b2, :reify => @b3)
    @b1.must_be.true
    @b2.must_be.false
    sol = @model.solve!
    sol.b3.value.should be_true
  end
end

