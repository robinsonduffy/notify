require 'spec_helper'

describe DeliveryOption do
  before(:each) do
    recipient = Factory(:recipient)
    @contact_method = Factory(:contact_method, {:recipient => recipient})
    @attrs = {:option_scope => 'self', :scope_id => recipient.id, :options => ['emergency']}
  end

  it "should create a delivery_option given correct attributes" do
    @contact_method.delivery_options.create!(@attrs)
  end

  describe "validations" do
    it "should require an option_scope" do
      bad_delivery_options = @contact_method.delivery_options.build(@attrs.merge(:option_scope => '   '))
      bad_delivery_options.should_not be_valid
    end

    it "should require a scope_id" do
      bad_delivery_options = @contact_method.delivery_options.build(@attrs.merge(:scope_id => '   '))
      bad_delivery_options.should_not be_valid
    end

  end
end
