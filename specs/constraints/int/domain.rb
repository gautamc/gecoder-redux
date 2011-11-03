require File.dirname(__FILE__) + '/../constraint_helper'

describe Gecode::Int::Domain, ' (non-range)' do
  before do
    @model = Gecode::Model.new
    @domain = 0..3
    @x = @model.int_var(@domain)
    @non_range_domain = [1, 3]

    @types = [:int]
    @invoke = lambda do |receiver, hash| 
      receiver.in(@non_range_domain, hash) 
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      if reif_var.nil?
        Gecode::Raw.should_receive(:dom).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var, an_instance_of(Gecode::Raw::IntSet), 
          *opts)
      else
        Gecode::Raw.should_receive(:dom).once.with(
          an_instance_of(Gecode::Raw::Space), 
          var, an_instance_of(Gecode::Raw::IntSet), 
          reif_var, *opts)
      end
    end
  end

  it 'should constrain the domain of the variable' do
    @x.must_be.in @non_range_domain
    @model.solve!

    @x.should have_domain(@non_range_domain)
  end

  it 'should handle negation' do
    @x.must_not_be.in @non_range_domain
    @model.solve!

    @x.should have_domain(@domain.to_a - @non_range_domain.to_a)
  end
  
  it_should_behave_like 'reifiable constraint'
end

describe Gecode::Int::Domain, ' (range)' do
  before do
    @model = Gecode::Model.new
    @domain = 0..3
    @operand = @x = @model.int_var(@domain)
    @range_domain = 1..2
    @three_dot_range_domain = 1...2
    
    @types = [:int]
    @invoke = lambda do |receiver, hash| 
      receiver.in(@range_domain, hash) 
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      @model.allow_space_access do
        if reif_var.nil?
          Gecode::Raw.should_receive(:dom).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var, @range_domain.first, @range_domain.last,
            *opts)
        else
          Gecode::Raw.should_receive(:dom).once.with(
            an_instance_of(Gecode::Raw::Space), 
            var, @range_domain.first, @range_domain.last,
            reif_var, *opts)
        end
      end
    end
  end

  it 'should constrain the domain of the variable' do
    @x.must_be.in @range_domain
    @model.solve!

    @x.should have_domain(@range_domain)
  end

  it 'should handle negation' do
    @x.must_not_be.in @range_domain
    @model.solve!

    @x.should have_domain(@domain.to_a - @range_domain.to_a)
  end

  it 'should treat three dot ranges correctly' do
    @x.must_be.in @three_dot_range_domain
    @model.solve!

    @x.should have_domain(@three_dot_range_domain)
  end

  it 'should handle three dot range with negation' do
    @x.must_not_be.in @three_dot_range_domain
    @model.solve!

    @x.should have_domain(@domain.to_a - @three_dot_range_domain.to_a)
  end
  
  it_should_behave_like 'reifiable constraint'
end
