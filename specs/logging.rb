require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::LoggingLayer do
  before do
    # Enable logging.
    Gecode.instance_eval{ remove_const(:Raw) }
    Gecode.const_set(:Raw, Gecode::LoggingLayer)
  end
  
  after do
    # Disable logging.
    Gecode.instance_eval{ remove_const(:Raw) }
    Gecode.const_set(:Raw, GecodeRaw)
  end

  it "shouldn't interfere with calls through Gecode::Raw" do
    lambda do
      model = Gecode::Model.new
      int_var = model.int_var(0..9)
      int_var.must >= 5
      model.solve!
    end.should_not raise_error
  end
end