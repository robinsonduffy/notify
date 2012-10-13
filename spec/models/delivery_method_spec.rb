require 'spec_helper'

describe DeliveryMethod do
  before(:each) do
    @attrs = {:message => Factory(:message), :contact_method_type => Factory(:contact_method_type), :from_method => Factory(:from_method)}
  end

  it "should create a delivery method if all the right attributes are provided" do
    DeliveryMethod.create!(@attrs)
  end

  describe "validations" do
    it "should require a message" do
      bad_delivery_method = DeliveryMethod.new(@attrs.merge(:message => nil))
      bad_delivery_method.should_not be_valid
    end

    it "should require a contact_method_type" do
      bad_delivery_method = DeliveryMethod.new(@attrs.merge(:contact_method_type => nil))
      bad_delivery_method.should_not be_valid
    end

    it "should require a from_method" do
      bad_delivery_method = DeliveryMethod.new(@attrs.merge(:from_method => nil))
      bad_delivery_method.should_not be_valid
    end

  end
end
