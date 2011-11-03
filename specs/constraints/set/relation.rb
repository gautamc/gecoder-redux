require File.dirname(__FILE__) + '/../constraint_helper'

Gecode::Util::SET_RELATION_TYPES.each_pair do |relation, type|
  next if relation == :==
  
  describe Gecode::Set::Relation, " (#{relation})" do
    before do
      @model = Gecode::Model.new
      @set = @model.set_var([0], 0..3)
      @set2 = @model.set_var([1], 0..3)
      @model.branch_on @model.wrap_enum([@set, @set2])
      
      @types = [:set, :set]
      @invoke = lambda do |receiver, set_op, hash| 
        receiver.method(relation).call(set_op, hash)
        @model.solve!
      end
      @expect = lambda do |var1, var2, opts, reif_var|
        if reif_var.nil? 
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var1, type, var2)
        else
          Gecode::Raw.should_receive(:rel).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var1, type, var2, reif_var)
        end
      end
    end

    it "should correctly constrain the set when #{relation} is used" do
      @set = @model.set_var if relation == :complement
      @set.must.method(relation).call(@set2)
      @model.solve!
      @set.should be_assigned
      @set2.should be_assigned
      case relation
        when :superset
          (@set2.value.to_a - @set.value.to_a).should be_empty
        when :subset
          (@set.value.to_a - @set2.value.to_a).should be_empty
        when :complement
          val = @set.value
          val.min.should == Gecode::Mixin::SET_MIN_INT
          val.max.should == Gecode::Mixin::SET_MAX_INT
          @set2.value.each do |element|
            @set.not_in_upper_bound?(element).should be_true
          end
        when :disjoint
          (@set2.value.to_a & @set.value.to_a).should be_empty
      end
    end

    it "should correctly constrain the set when negated #{relation} is used" do
      @set.must_not.method(relation).call(@set2)
      @model.solve!
      @set.should be_assigned
      @set2.should be_assigned
      case relation
        when :superset
          (@set2.value.to_a - @set.value.to_a).should_not be_empty
        when :subset
          (@set.value.to_a - @set2.value.to_a).should_not be_empty
        when :complement
          val = @set.value
          ((val.min != Gecode::Mixin::SET_MIN_INT) || 
            (val.max != Gecode::Mixin::SET_MAX_INT) ||
            @set.value.to_a.any?{ |element| @set.in_lower_bound?(element) }
          ).should be_true
        when :disjoint
          (@set.value.to_a & @set.value.to_a).should_not be_empty
      end
    end
    
    it_should_behave_like 'reifiable set constraint'
  end
end

describe Gecode::Set::Relation, ' (equality)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([0], 0..1)
    @set2 = @model.set_var([1], 0..1)
    @model.branch_on @model.wrap_enum([@set, @set2])

    @types = [:set, :set]
    @invoke = lambda do |receiver, set_op, hash| 
      receiver.equal(set_op, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      if reif_var.nil? 
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var1, Gecode::Raw::SRT_EQ, var2)
      else
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var1, Gecode::Raw::SRT_EQ, var2, reif_var)
      end
    end
  end

  it 'should constrain sets to be equal' do
    @set.must == @set2
    @model.solve!
    @set.value.to_a.should == @set2.value.to_a
  end
  
  it 'should constrain sets to not be equal when negated' do
    @set.must_not == @set2
    @model.solve!
    @set.value.to_a.should_not == @set2.value.to_a
  end
  
  it_should_behave_like 'reifiable set constraint'
end
