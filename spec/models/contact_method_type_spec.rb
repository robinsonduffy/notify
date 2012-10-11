require 'spec_helper'

describe ContactMethodType do
  before(:each) do
    @attrs = {:name => "SMS"}
  end

  it "should create a school if all the right attributes are provided" do
    ContactMethodType.create!(@attrs)
  end

  describe "validations" do
    it "should require a name" do
      bad_contact_method_type = ContactMethodType.new(@attrs.merge(:name => '    '))
      bad_contact_method_type.should_not be_valid
    end

    it "should require a unique name" do
      ContactMethodType.create!(@attrs)
      bad_contact_method_type = ContactMethodType.new(@attrs)
      bad_contact_method_type.should_not be_valid
    end
  end
end
