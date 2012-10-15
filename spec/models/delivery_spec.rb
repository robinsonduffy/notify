require 'spec_helper'

describe Delivery do
  before(:each) do
    @attrs = {:delivered_message => "This is my test message", :delivery_result => 1, :contact_method_id => 1, :delivery_method_id => 2}
  end

  it "should create a message if all the right attributes are provided" do
    Delivery.create!(@attrs)
  end

  describe "validations" do
    it "should require a delivered_message" do
      bad_delivery = Delivery.new(@attrs.merge(:delivered_message => '    '))
      bad_delivery.should_not be_valid
    end

    it "should require a delivery_result" do
      bad_delivery = Delivery.new(@attrs.merge(:delivery_result => nil))
      bad_delivery.should_not be_valid
    end

    it "should require a valid delivery_result" do
      bad_delivery = Delivery.new(@attrs.merge(:delivery_result => 105))
      bad_delivery.should_not be_valid
    end

    it "should require a contact_method" do
      bad_delivery = Delivery.new(@attrs.merge(:contact_method_id => nil))
      bad_delivery.should_not be_valid
    end

    it "should require a delivery_method" do
      bad_delivery = Delivery.new(@attrs.merge(:delivery_method_id => nil))
      bad_delivery.should_not be_valid
    end
  end
end
