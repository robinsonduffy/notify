require 'spec_helper'

describe ContactMethod do
  before(:each) do
    @recipient = Factory(:recipient)
    @attrs = {:contact_method_type => 'phone', :delivery_route => '19076990602'}
  end

  it "should create a contact_method given correct attributes" do
    @recipient.contact_methods.create!(@attrs)
  end

  describe "validations" do
    it "should require a contact_method_type" do
      bad_contact_method = @recipient.contact_methods.build(@attrs.merge(:contact_method_type => '   '))
      bad_contact_method.should_not be_valid
    end

    it "should require a delivery_route" do
      bad_contact_method = @recipient.contact_methods.build(@attrs.merge(:delivery_route => '   '))
      bad_contact_method.should_not be_valid
    end

    it "should require a unique delivery_route/contact_method_type/recipient_id combination" do
      @recipient.contact_methods.create!(@attrs)
      bad_contact_method = @recipient.contact_methods.build(@attrs)
      bad_contact_method.should_not be_valid
    end

    it "should allow a delivery_route to have more than one contact_method_type" do
      @recipient.contact_methods.create!(@attrs)
      good_contact_method = @recipient.contact_methods.build(@attrs.merge(:contact_method_type => 'sms'))
      good_contact_method.should be_valid
    end
  end
end
