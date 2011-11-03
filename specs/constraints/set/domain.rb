require File.dirname(__FILE__) + '/../constraint_helper'

Gecode::Util::SET_RELATION_TYPES.each_pair do |relation, type|
  next if relation == :==
  
  describe Gecode::Set::Domain, " (#{relation})" do
    include GecodeR::Specs::SetHelper

    before do
      @model = Gecode::Model.new
      @glb = []
      @lub = 0..3
      @set = @model.set_var(@glb, @lub)
      @model.branch_on @set
      @range = 0..1
      @non_range = [0, 2]
      @singleton = 0
      
      @types = [:set]
      @invoke = lambda do |receiver, hash| 
        receiver.method(relation).call(@non_range, hash)
        @model.solve!
      end
      @expect = lambda do |var, opts, reif_var|
        @expect_with_rhs.call(var, opts, reif_var, @non_range)
      end
      @expect_with_rhs = lambda do |var, opts, reif_var, rhs|
        if reif_var.nil?
          Gecode::Raw.should_receive(:dom).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var, type, 
            *expect_constant_set(rhs))
        else
          params = [an_instance_of(Gecode::Raw::Space), 
            var, type]
          params << expect_constant_set(rhs)
          params << reif_var
          Gecode::Raw.should_receive(:dom).once.with(*params.flatten)
        end
      end
    end
  
    it "should translate #{relation} with constant range to domain constraint" do
      @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
        nil, nil, @range)
      @set.must.send(relation, @range)
      @model.solve!
    end
    
    it "should translate #{relation} with constant non-range to domain constraint" do
      @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
        nil, nil, @non_range)
      @set.must.send(relation, @non_range)
      @model.solve!
    end
    
    it "should translate #{relation} with constant singleton to domain constraint" do
      @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
        nil, nil, @singleton)
      @set.must.send(relation, @singleton)
      @model.solve!
    end
  
    it 'should raise error if the right hand side is not a constant set' do
      lambda do
        @set.must.send(relation, 'not a constant set')
      end.should raise_error(TypeError)
    end

    it "should constrain the domain when #{relation} is used" do
      @set = @model.set_var if relation == :complement
      @set.must.method(relation).call(@non_range)
      @model.solve!
      @set.should be_assigned
      case relation
        when :superset
          (@non_range - @set.value.to_a).should be_empty
        when :subset
          (@set.value.to_a - @non_range).should be_empty
        when :complement
          val = @set.value
          val.min.should == Gecode::Mixin::SET_MIN_INT
          val.max.should == Gecode::Mixin::SET_MAX_INT
          @non_range.each do |element|
            @set.not_in_upper_bound?(element).should be_true
          end
        when :disjoint
          (@non_range & @set.value.to_a).should be_empty
      end
    end

    it "should constrain the domain when negated #{relation} is used" do
      @set.must_not.method(relation).call(@non_range)
      @model.solve!
      @set.should be_assigned
      case relation
        when :superset
          (@non_range - @set.value.to_a).should_not be_empty
        when :subset
          (@set.value.to_a - @non_range).should_not be_empty
        when :complement
          val = @set.value
          ((val.min != Gecode::Mixin::SET_MIN_INT) || 
            (val.max != Gecode::Mixin::SET_MAX_INT) ||
            @non_range.any?{ |element| @set.in_lower_bound?(element) }
          ).should be_true
        when :disjoint
          (@non_range & @set.value.to_a).should_not be_empty
      end
    end

    it_should_behave_like 'reifiable set constraint'
  end
end

describe Gecode::Set::Domain, ' (equality)' do
  include GecodeR::Specs::SetHelper

  before do
    @model = Gecode::Model.new
    @glb = [0]
    @lub = 0..3
    @set = @model.set_var(@glb, @lub)
    @range = 0..1
    @non_range = [0, 2]
    @singleton = 0
    @model.branch_on @model.wrap_enum([@set])
    
    @types = [:set]
    @invoke = lambda do |receiver, hash| 
      receiver.equal(@non_range, hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      @expect_with_rhs.call(var, opts, reif_var, @non_range)
    end
    @expect_with_rhs = lambda do |var, opts, reif_var, rhs|
      if reif_var.nil?
        Gecode::Raw.should_receive(:dom).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var, Gecode::Raw::SRT_EQ, 
          *expect_constant_set(rhs))
      else
        params = [an_instance_of(Gecode::Raw::Space), 
          var, Gecode::Raw::SRT_EQ]
        params << expect_constant_set(rhs)
        params << reif_var
        Gecode::Raw.should_receive(:dom).once.with(*params.flatten)
      end
    end
  end
  
  it 'should translate equality with constant range to domain constraint' do
    @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
      nil, nil, @range)
    @set.must == @range
    @model.solve!
  end
  
  it 'should translate equality with constant non-range to domain constraint' do
    @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
      nil, nil, @non_range)
    @set.must == @non_range
    @model.solve!
  end
  
  it 'should translate equality with constant singleton to domain constraint' do
    @expect_with_rhs.call(@model.allow_space_access{ @set.bind }, 
      nil, nil, @singleton)
    @set.must == @singleton
    @model.solve!
  end
  
  it 'should constrain the domain with equality' do
    @set.must == @singleton
    @model.solve!
    @set.should be_assigned
    @set.value.should include(@singleton)
    @set.value.size.should == 1
  end
  
  it 'should constrain the domain with inequality' do
    @set.must_not == @singleton
    @model.solve!
    @set.should be_assigned
    @set.value.should include(@singleton)
    ((@set.value.size > 1) || (@set.value != [@singleton])).should be_true
  end

  it 'should raise error if the right hand side is not a constant set' do
    lambda do
      @set.must == 'not a constant set'
    end.should raise_error(TypeError)
  end
  
  it_should_behave_like 'reifiable set constraint'
end
