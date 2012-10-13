require 'spec_helper'

describe Script do
  before(:each) do
    @attrs = {:script_type => 'text', :script => 'This is my test script', :delivery_method => Factory(:delivery_method, :message => Factory(:message), :from_method => Factory(:from_method), :contact_method_type => Factory(:contact_method_type))}
  end

  it "should create a script if all the right attributes are provided" do
    Script.create!(@attrs)
  end

  describe "validations" do
    it "should require a script_type" do
      bad_script = Script.new(@attrs.merge(:script_type => '   '))
      bad_script.should_not be_valid
    end

    it "should require a script" do
      bad_script = Script.new(@attrs.merge(:script => '   '))
      bad_script.should_not be_valid
    end

    it "should require a delivery_method" do
      bad_script = Script.new(@attrs.merge(:delivery_method => nil))
      bad_script.should_not be_valid
    end

  end
end
