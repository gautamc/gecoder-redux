require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::Util::EnumMatrix do
  before do
    @matrix = Gecode::Util::EnumMatrix[[0, 1], [1, 0]]
  end
  
  it 'should be enumerable' do
    @matrix.should be_kind_of(Enumerable)
  end
  
  it 'should produce rows that are enumerable' do
    @matrix.row(0).should be_kind_of(Enumerable)
    @matrix.row(0).inject([]){ |arr, e| arr << e }.should == [0, 1]
  end
  
  it 'should produce columns that are enumerable' do
    @matrix.column(0).should be_kind_of(Enumerable)
  end
  
  it 'should produce submatrices that are enumerable' do
    @matrix.minor(0,1,0,1).should be_kind_of(Enumerable)
  end
end

describe Gecode::Util::EnumMatrix, ' (when wrapped)' do
  before do
    @model = Gecode::Model.new
    @matrix = @model.wrap_enum(Gecode::Util::EnumMatrix[[0, 1], [1, 0]])
  end
  
  it 'should produce rows that are wrapped' do
    @matrix.row(0).should respond_to(:model)
  end
  
  it 'should produce columns that are enumerable' do
    @matrix.column(0).should respond_to(:model)
  end
  
  it 'should produce submatrices that are enumerable' do
    @matrix.minor(0,1,0,1).should respond_to(:model)
  end
end