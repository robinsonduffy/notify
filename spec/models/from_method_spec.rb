require 'spec_helper'

describe FromMethod do
  before(:each) do
    @attrs = {:from_method_type => "email", :from_method => "test@example.com", :name => "Test Email"}
  end

  it "should create a from_method if all the right attributes are provided" do
    FromMethod.create!(@attrs)
  end

  describe "validations" do
    it "should require a from_method_type" do
      bad_from = FromMethod.new(@attrs.merge(:from_method_type => '    '))
      bad_from.should_not be_valid
    end

    it "should require a from_method" do
      bad_from = FromMethod.new(@attrs.merge(:from_method => '    '))
      bad_from.should_not be_valid
    end

    it "should require a unique from_method/from_method_type combo" do
      FromMethod.create!(@attrs)
      bad_from = FromMethod.new(@attrs)
      bad_from.should_not be_valid
    end

    it "should allow from_method to be the same for a different from_method_type" do
      FromMethod.create!(@attrs)
      good_from = FromMethod.new(@attrs.merge(:from_method_type => 'phone'))
      good_from.should be_valid
    end
  end
end
