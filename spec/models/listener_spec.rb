require 'spec_helper'

describe Listener do

  it "should create an uid before validation" do
    subject.valid?
    subject.uid.should_not be_nil
  end

end
