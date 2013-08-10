require 'spec_helper'

describe DurationHelper do

  describe "#format_duration" do

    it "should return '4:30' for 270" do
      helper.format_duration(270).should == '4:30'
    end

    it "should return '4:01' for 241" do
      helper.format_duration(241).should == '4:01'
    end

    it "should return '62:30' for 3750" do
      helper.format_duration(3750).should == '62:30'
    end

  end

end
