require File.dirname(__FILE__) + '/spec_helper'

describe Gecode, ' (Model sugar)' do
  it 'should provide #solve as sugar for constructing a model and running solve!' do
    Gecode.solve do
      numbers_is_an int_var_array(2, 0..5)
      x, y = numbers
      (x * y).must == 25
      branch_on numbers
    end.numbers.values.should == [5,5]
  end

  it 'should provide #maximize as sugar for constructing a model and running maximize!' do
    Gecode.maximize :z do
      z_is_an int_var
      x, y = vars = int_var_array(2, 0..5)
      (x*2 - y).must == z
      branch_on vars
    end.z.value.should equal(10)
  end

  it 'should provide #minimize as sugar for constructing a model and running minimize!' do
    Gecode.minimize :z do
      z_is_an int_var
      x, y = vars = int_var_array(2, 0..5)
      (x*2 - y).must == z
      branch_on vars
    end.z.value.should equal(-5)
  end
end
