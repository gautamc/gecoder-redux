require File.dirname(__FILE__) + '/../spec_helper'

describe Gecode::Constraint, ' (not subclassed)' do
  before do
    @con = Gecode::Constraint.new(Gecode::Model.new, {})
  end

  it 'should raise error when calling #post because it\'s not overridden' do
    lambda{ @con.post }.should raise_error(NotImplementedError)
  end
end

describe Gecode::Util do
  it 'should raise error when giving incorrect set to #constant_set_to_params' do
    lambda do 
      Gecode::Util.constant_set_to_params('hello')
    end.should raise_error(TypeError)
  end
  
  it 'should raise error when giving incorrect set to #constant_set_to_int_set' do
    lambda do 
      Gecode::Util.constant_set_to_int_set('hello')
    end.should raise_error(TypeError)
  end
end

