require File.dirname(__FILE__) + '/spec_helper'
require 'set'

class SampleProblem
  include Gecode::Mixin

  attr :var
  attr :array
  attr :hash
  attr :nested_enum
  
  def initialize(domain)
    vars = self.int_var_array(1,domain)
    @var = vars.first
    @var.must > 1
    @array = [@var]
    @hash = {:a => var}
    @nested_enum = [1,2,[@var],[7, {:b => var}]]
    
    branch_on vars, :variable => :smallest_size, :value => :min
  end
end

class DifficultSampleProblem
  include Gecode::Mixin

  def initialize
    # The magic sequence problem with a large n.
    n = 500
    sequence_is_an int_var_array(n, 0...n)
    n.times{ |i| sequence.count(i).must == sequence[i] }
    sequence.inject{ |x,y| x + y }.must == n
    sequence.zip((-1...n).to_a).map do |element, c| 
      element*c
    end.inject{ |x,y| x + y }.must == 0

    branch_on sequence, :variable => :smallest_degree, :value => :split_max
  end
end

class SampleOptimizationProblem
  include Gecode::Mixin

  attr :x
  attr :y
  attr :z
  
  def initialize
    @x,@y = int_var_array(2, 0..5)
    @z = int_var(0..25)
    (@x * @y).must == @z 
    
    branch_on wrap_enum([@x, @y]), :variable => :smallest_size, :value => :min
  end
end

class SampleOptimizationProblem2
  include Gecode::Mixin

  attr :money
  
  def initialize
    @money = int_var_array(3, 0..9)
    @money.must_be.distinct
    @money.to_number.must < 500 # Otherwise it takes some time.
    
    branch_on @money, :variable => :smallest_size, :value => :min
  end
end

class Array
  # Computes a number of the specified base using the array's elements as 
  # digits.
  def to_number(base = 10)
    inject{ |result, variable| variable + result * base }
  end
end

describe Gecode::Mixin, ' (with multiple solutions)' do
  before do
    @domain = 0..3
    @solved_domain = [2]
    @model = SampleProblem.new(@domain)
  end

  it 'should pass a solution to the block given in #solution' do
    @model.solution do |s|
      s.var.should have_domain(@solved_domain)
    end
  end

  it 'should update the search statistics before yielding to #solution' do
    @model.solution do |s|
      @model.search_stats.should_not be_nil
    end
  end
  
  it 'should only evaluate the block for one solution in #solution' do
    i = 0
    @model.solution{ |s| i += 1 }
    i.should equal(1)
  end
  
  it 'should return the result of the block when calling #solution' do
    @model.solution{ |s| 'test' }.should == 'test'
  end
  
  it 'should pass every solution to #each_solution' do
    solutions = []
    @model.each_solution do |s|
      solutions << s.var.value
    end
    Set.new(solutions).should == Set.new([2,3])
  end
  
  it 'should update the search statistics before yielding to #each_solution' do
    solutions = []
    old_stats = @model.search_stats
    old_stats.should be_nil
    @model.each_solution do |s|
      solutions << s.var.value
      @model.search_stats.should_not == old_stats
      @model.search_stats.should_not be_nil
      old_stats = @model.search_stats
    end
  end
end

describe Gecode::Mixin, ' (after #solve!)' do
  before do
    @domain = 0..3
    @solved_domain = [2]
    @model = SampleProblem.new(@domain)
    @model.solve!
  end

  it 'should have updated the variables domains' do
    @model.var.should have_domain(@solved_domain)
  end

  it 'should have updated variables in arrays' do
    @model.array.first.should have_domain(@solved_domain)
  end
  
  it 'should have updated variables in hashes' do
    @model.hash.values.first.should have_domain(@solved_domain)
  end
  
  it 'should have updated variables in nested enums' do
    enum = @model.solve!.nested_enum
    enum[2].first.should have_domain(@solved_domain)
    enum[3][1][:b].should have_domain(@solved_domain)
    
    enum = @model.nested_enum
    enum[2].first.should have_domain(@solved_domain)
    enum[3][1][:b].should have_domain(@solved_domain)
  end
  
  it 'should have updated the search statistics' do
    stats = @model.search_stats
    stats[:propagations].should == 0
    stats[:failures].should == 0
    stats[:clones].should_not be_nil
    stats[:commits].should_not be_nil
    stats[:memory].should > 0
  end
end

describe 'reset model', :shared => true do
  it 'should have reset variables' do
    @model.var.should have_domain(@reset_domain)
  end
  
  it 'should have reset variables in nested enums' do
    enum = @model.nested_enum
    enum[2].first.should have_domain(@reset_domain)
    enum[3][1][:b].should have_domain(@reset_domain)
  end
  
  it 'should have cleared the search statistics' do
    @model.search_stats.should be_nil
  end
end

describe Gecode::Mixin, ' (after #reset!)' do
  before do
    @domain = 0..3
    @reset_domain = 2..3
    @model = SampleProblem.new(@domain)
    @model.solve!
    @model.reset!
  end
  
  it_should_behave_like 'reset model'
end

describe Gecode::Mixin, ' (after #solution)' do
  before do
    @domain = 0..3
    @reset_domain = 2..3
    @model = SampleProblem.new(@domain)
    @model.solution{ |s| }
  end
  
  it_should_behave_like 'reset model'
end

describe Gecode::Mixin, ' (after #each_solution)' do
  before do
    @domain = 0..3
    @reset_domain = 2..3
    @model = SampleProblem.new(@domain)
    @model.each_solution{ |s| }
  end
  
  it_should_behave_like 'reset model'
end

describe Gecode::Mixin, ' (without solution)' do
  before do
    @domain = 0..3
    @model = SampleProblem.new(@domain)
    @model.var.must < 0
  end
  
  it 'should return nil when calling #solution' do
    @model.solution{ |s| 'test' }.should be_nil
  end

  it 'should not yield anything to #each_solution' do 
    @model.each_solution{ |s| violated }
  end
  
  it 'should raise NoSolutionError when calling #solve!' do
    lambda do 
      @model.solve!
    end.should raise_error(Gecode::NoSolutionError)
  end
  
  it 'should raise NoSolutionError when calling #optimize!' do
    lambda do 
      @model.optimize!{}
    end.should raise_error(Gecode::NoSolutionError)
  end

  it 'should raise NoSolutionError when calling #minimize!' do
    lambda do 
      @model.optimize!{}
    end.should raise_error(Gecode::NoSolutionError)
  end

  it 'should raise NoSolutionError when calling #maximize!' do
    lambda do 
      @model.maximize!(:var)
    end.should raise_error(Gecode::NoSolutionError)
  end
end

describe Gecode::Mixin, ' (without constraints)' do
  before do
    @model = Gecode::Model.new
    @x = @model.int_var(0..1)
  end
  
  it 'should produce a solution' do
    @model.solve!.should_not be_nil
  end
end

describe Gecode::Mixin, '(optimization search)' do
  it 'should optimize the solution' do
    solution = SampleOptimizationProblem.new.optimize! do |model, best_so_far|
      model.z.must > best_so_far.z.value
    end
    solution.should_not be_nil
    solution.x.value.should == 5
    solution.y.value.should == 5
    solution.z.value.should == 25
  end
  
  it 'should not be bothered by garbage collecting' do
    # This goes through 400+ spaces.
    solution = SampleOptimizationProblem2.new.optimize! do |model, best_so_far|
      model.money.to_number.must > best_so_far.money.values.to_number
    end
    solution.should_not be_nil
    solution.money.values.to_number.should == 498
  end
  
  it 'should raise error if no constrain proc has been defined' do
    lambda do 
      Gecode::Mixin.constrain(nil, nil) 
    end.should raise_error(NotImplementedError)
  end
  
  it 'should not have problems with variables being created in the optimization block' do
    solution = SampleOptimizationProblem.new.optimize! do |model, best_so_far|
      tmp = model.int_var(0..25)
      tmp.must == model.z
      tmp.must > best_so_far.z.value
    end
    solution.should_not be_nil
    solution.x.value.should == 5
    solution.y.value.should == 5
    solution.z.value.should == 25
  end

  it 'should not have problems with variables being created in the optimization block (2)' do
    solution = SampleOptimizationProblem.new.optimize! do |model, best_so_far|
      tmp = model.int_var(0..25)
      tmp.must == model.z
      (tmp + tmp).must > best_so_far.z.value*2
    end
    solution.should_not be_nil
    solution.x.value.should == 5
    solution.y.value.should == 5
    solution.z.value.should == 25
  end
  
  it 'should update the search statistics' do
    model = SampleOptimizationProblem.new
    solution = model.maximize! :z
    
    stats = model.search_stats
    stats.should_not be_nil
    stats[:propagations].should be_between(1, 100)
    stats[:failures].should be_between(1, 100)
    stats[:clones].should_not be_nil
    stats[:commits].should_not be_nil
    stats[:memory].should > 0
  end
end

describe 'single variable optimization', :shared => true do
  it "should support #{@method_name} having the variable given as a symbol" do
    solution = @model.method(@method_name).call(@variable_name.to_sym)
    @expect_to_be_correct.call(solution)
  end
  
  it "should support #{@method_name} having the variable given as a string" do
    solution = @model.method(@method_name).call(@variable_name.to_s)
    @expect_to_be_correct.call(solution)
  end
  
  it "should raise error if #{@method_name} is given a non-existing method" do
    lambda do
      SampleOptimizationProblem.new.method(@method_name).call(:does_not_exist)
    end.should raise_error(NameError)
  end
  
  it "should raise error if #{@method_name} is given a method that does not return an integer variable" do
    lambda do
      SampleOptimizationProblem.new.method(@method_name).call(:object_id)
    end.should raise_error(ArgumentError)
  end
  
  it 'should update the search statistics' do
    @model.method(@method_name).call(@variable_name.to_sym)
    
    stats = @model.search_stats
    stats.should_not be_nil
    stats[:propagations].should be_between(1, 100)
    stats[:failures].should be_between(1, 100)
    stats[:clones].should_not be_nil
    stats[:commits].should_not be_nil
    stats[:memory].should > 0
  end
end

describe Gecode::Mixin, '(single variable minimization)' do
  before do
    @method_name = 'minimize!'
    @variable_name = 'x'
    
    @model = SampleOptimizationProblem.new
    @model.z.must > 2
    
    @expect_to_be_correct = lambda do |solution|
      solution.should_not be_nil
      solution.x.value.should == 1
      solution.y.value.should == 3
      solution.z.value.should == 3
    end
  end
  
  it_should_behave_like 'single variable optimization'
end

describe Gecode::Mixin, '(single variable maximization)' do
  before do
    @method_name = 'maximize!'
    @variable_name = 'z'
    
    @model = SampleOptimizationProblem.new
    
    @expect_to_be_correct = lambda do |solution|
      solution.should_not be_nil
      solution.x.value.should == 5
      solution.y.value.should == 5
      solution.z.value.should == 25
    end
  end
  
  it_should_behave_like 'single variable optimization'
end

describe Gecode::Mixin, ' (with time limitations)' do
  it 'should not time out problems that finish within the time limitation' do
    @domain = 0..3
    @solved_domain = [2]
    @model = SampleProblem.new(@domain)
    lambda do
      @model.solve!(:time_limit => 50)
    end.should_not raise_error(Gecode::SearchAbortedError)
  end
  
  it 'should time out problems that do not finish within the time limitation' do
    @model = DifficultSampleProblem.new
    lambda do
      t = Time.now
      @model.solve!(:time_limit => 50)
      puts Time.now - t
    end.should raise_error(Gecode::SearchAbortedError)
  end
  
  it 'should raise error if an unrecognised option is passed' do
    @model = DifficultSampleProblem.new
    lambda do
      @model.solve!(:time_limit => 50, :foo => 1)
    end.should raise_error(ArgumentError)
  end
end
