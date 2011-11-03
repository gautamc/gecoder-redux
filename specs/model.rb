require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::Mixin, ' (integer creation)' do
  before do
    @model = Gecode::Model.new
  end

  it 'should allow the creation of int variables with range' do
    range = 0..3
    @model.int_var(range).should have_domain(range)
  end

  it 'should allow the creation of int variables without specified domain' do
    var = @model.int_var
    var.should be_range
    var.min.should == Gecode::Raw::IntLimits::MIN
    var.max.should == Gecode::Raw::IntLimits::MAX
  end

  it 'should allow the creation of int variables with non-range domains' do
    domain = [1, 3, 5]
    @model.int_var(domain).should have_domain(domain)
  end
  
  it 'should allow the creation of int variables with single element domains' do
    domain = 3
    @model.int_var(domain).should have_domain([domain])
  end
  
  it 'should allow the creation of int-var arrays with range domains' do
    range = 0..3
    count = 5
    vars = @model.int_var_array(count, range)
    vars.size.should equal(count)
    vars.each{ |var| var.should have_domain(range) }
  end
  
  it 'should allow the creation of int-var arrays with non-range domains' do
    domain = [1,3,5]
    count = 5
    vars = @model.int_var_array(count, domain)
    vars.size.should equal(count)
    vars.each{ |var| var.should have_domain(domain) }
  end
  
  it 'should allow the creation of int-var arrays without specified domain' do
    count = 5
    vars = @model.int_var_array(count)
    vars.size.should equal(count)
    vars.each do |var|
      var.should be_range
      var.min.should == Gecode::Raw::IntLimits::MIN
      var.max.should == Gecode::Raw::IntLimits::MAX
    end
  end
  
  it 'should allow the creation of int-var matrices with range domains' do
    range = 0..3
    rows = 5
    columns = 4
    vars = @model.int_var_matrix(rows, columns, range)
    vars.row_size.should equal(rows)
    vars.column_size.should equal(columns)
    vars.each{ |var| var.should have_domain(range) }
  end
  
  it 'should allow the creation of int-var matrices with non-range domains' do
    domain = [1,3,5]
    rows = 5
    columns = 4
    vars = @model.int_var_matrix(rows, columns, domain)
    vars.row_size.should equal(rows)
    vars.column_size.should equal(columns)
    vars.each{ |var| var.should have_domain(domain) }
  end
  
  it 'should allow the creation of int-var matrices without specified domain' do
    rows = 5
    columns = 4
    vars = @model.int_var_matrix(rows, columns)
    vars.row_size.should equal(rows)
    vars.column_size.should equal(columns)
    vars.each do |var|
      var.should be_range
      var.min.should == Gecode::Raw::IntLimits::MIN
      var.max.should == Gecode::Raw::IntLimits::MAX
    end
  end
  
  it 'should raise error if the domain is of incorrect type' do
    lambda do 
      @model.int_var(nil)
    end.should raise_error(TypeError) 
  end
  
  it 'should gracefully GC a variable that was never accessed' do
    lambda do
      @model.int_var 0
      GC.start
    end.should_not raise_error
  end
end

describe Gecode::Mixin, ' (bool creation)' do
  before do
    @model = Gecode::Model.new
  end

  it 'should allow the creation of boolean variables' do
    @model.bool_var.should_not be_nil
  end
  
  it 'should allow the creation of arrays of boolean variables' do
    @model.bool_var_array(3).size.should equal(3)
  end
  
  it 'should allow the creation of matrices of boolean variables' do
    matrix = @model.bool_var_matrix(3, 4)
    matrix.row_size.should equal(3)
    matrix.column_size.should equal(4)
  end
  
  it 'should gracefully GC a variable that was never accessed' do
    lambda do
      @model.bool_var
      GC.start
    end.should_not raise_error
  end
end

describe Gecode::Mixin, ' (set creation)' do
  before do
    @model = Gecode::Model.new
    @glb_range = 0..3
    @lub_range = 0..5
    @glb_enum = [0, 3]
    @lub_enum = [0, 1, 2, 3, 5]
    @lower_card = 1
    @upper_card = 3
  end
  
  it 'should allow the creation of set variables without specified bounds' do
    var = @model.set_var
    var.lower_bound.size.should == 0
    var.upper_bound.min.should == Gecode::Raw::SetLimits::MIN
    var.upper_bound.max.should == Gecode::Raw::SetLimits::MAX
  end

  it 'should allow the creation of set variables with glb range and lub range' do
    @model.set_var(@glb_range, @lub_range).should have_bounds(@glb_range, 
      @lub_range) 
  end
  
  it 'should allow the creation of set variables with glb enum and lub range' do
    @model.set_var(@glb_enum, @lub_range).should have_bounds(@glb_enum, 
      @lub_range) 
  end
  
  it 'should allow the creation of set variables with glb range and lub enum' do
    @model.set_var(@glb_range, @lub_enum).should have_bounds(@glb_range, 
      @lub_enum) 
  end
  
  it 'should allow the creation of set variables with glb enum and lub enum' do
    @model.set_var(@glb_enum, @lub_enum).should have_bounds(@glb_enum, 
      @lub_enum) 
  end
  
  it 'should allow the creation of set variables with specified lower cardinality bound' do
    @model.set_var(@glb_range, @lub_range, 
      @lower_card).cardinality.begin.should >= @lower_card
  end
  
  it 'should allow the creation of set variables with specified cardinality range' do
    var = @model.set_var(@glb_range, @lub_range, @lower_card..@upper_card)
    var.cardinality.end.should <= @upper_card
    var.cardinality.begin.should >= @lower_card
  end
  
  it 'should allow the creation of arrays of set variables' do
    arr = @model.set_var_array(3, @glb_enum, @lub_enum, @lower_card..@upper_card)
    arr.size.should == 3
    arr.each do |var|
      var.should have_bounds(@glb_enum, @lub_enum)
      var.cardinality.end.should <= @upper_card
      var.cardinality.begin.should >= @lower_card
    end
  end
  
  it 'should allow the creation of arrays of set variables without specified bounds' do
    vars = @model.set_var_array(3)
    vars.each do |var|
      var.lower_bound.size.should == 0
      var.upper_bound.min.should == Gecode::Raw::SetLimits::MIN
      var.upper_bound.max.should == Gecode::Raw::SetLimits::MAX
    end
  end
  
  it 'should allow the creation of matrices of set variables' do
    matrix = @model.set_var_matrix(4, 5, @glb_enum, @lub_enum, 
      @lower_card..@upper_card)
    matrix.row_size.should == 4
    matrix.column_size.should == 5
    matrix.each do |var|
      var.should have_bounds(@glb_enum, @lub_enum)
      var.cardinality.end.should <= @upper_card
      var.cardinality.begin.should >= @lower_card
    end
  end

  it 'should allow the creation of matrices of set variables without specified bounds' do
    matrix = @model.set_var_matrix(4, 5)
    matrix.each do |var|
      var.lower_bound.size.should == 0
      var.upper_bound.min.should == Gecode::Raw::SetLimits::MIN
      var.upper_bound.max.should == Gecode::Raw::SetLimits::MAX
    end
  end
  
  it 'should raise error if glb and lub are not valid when they are given as range' do
    lambda do 
      @model.set_var(@lub_range, @glb_range)
    end.should raise_error(ArgumentError)  
  end
  
  it 'should raise error if glb and lub are not valid when one is given as enum' do
    lambda do
      @model.set_var(@lub_range, @glb_enum)
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise error if glb and lub are not valid when both are given as enums' do
    lambda do
      @model.set_var(@lub_enum, @glb_enum)
    end.should raise_error(ArgumentError)  
  end
  
  it 'should raise error if the glb and lub are of incorrect type' do
    lambda do 
      @model.set_var("foo\n", "foo\ns")
    end.should raise_error(TypeError) 
  end

  it 'should gracefully GC a variable that was never accessed' do
    lambda do
      @model.set_var(@glb_range, @lub_range)
      GC.start
    end.should_not raise_error
  end
end

describe Gecode::Mixin, ' (space access restriction)' do
  before do
    @model = Gecode::Model.new
  end

  it 'should raise error if not allowed to access space' do
    lambda{ @model.active_space }.should raise_error(RuntimeError)
  end
  
  it 'should not raise error because of space restriction if allowed to access space' do
    lambda do
      @model.allow_space_access do
        @model.active_space
      end
    end.should_not raise_error(RuntimeError)
  end
end

describe Gecode::Mixin, ' (accessible variable creation)' do
  before do
    @model = Class.new(Gecode::Model).new
  end

  it 'should allow creation of named variable using #foo_is_a' do
    var = @model.int_var(17)
    lambda{ @model.foo }.should raise_error(NoMethodError)
    @model.instance_eval{ foo_is_a var }
    lambda{ @model.foo }.should_not raise_error
    @model.foo.should == var
  end

  it 'should allow creation of named variable using #foo_is_an' do
    var = @model.int_var(17)
    lambda{ @model.foo }.should raise_error(NoMethodError)
    @model.instance_eval{ foo_is_an var }
    lambda{ @model.foo }.should_not raise_error
    @model.foo.should == var
  end

  it 'should only allow one argument to be given to #foo_is_a' do
    lambda do
      @model.instance_eval{ foo_is_a }
    end.should raise_error(ArgumentError)
    lambda do
      @model.instance_eval{ foo_is_a bool_var, bool_var }
    end.should raise_error(ArgumentError)
  end

  it 'should only define the variable in the current instance' do
    klass = Class.new Gecode::Model
    model_a = klass.new
    model_b = klass.new

    model_a.instance_eval{ bar_is_a bool_var }
    lambda{ model_a.bar }.should_not raise_error
    lambda{ model_b.bar }.should raise_error(NoMethodError)
  end

  it 'should raise error if a method would be overwritten' do
    var = @model.int_var(17)
    lambda{ @model.class }.should_not raise_error
    lambda do
      @model.instance_eval{ class_is_an var } 
    end.should raise_error(ArgumentError)
  end

  it 'should raise error if an instance variable would be overwritten' do
    @model.instance_eval{ @foo = 17 }
    var = @model.int_var(17)
    lambda do
      @model.instance_eval{ foo_is_a var } 
    end.should raise_error(ArgumentError)
  end
end
