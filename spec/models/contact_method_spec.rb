require 'spec_helper'

describe ContactMethod do
  before(:each) do
    @recipient = Factory(:recipient)
    @contact_method_type_phone = Factory(:contact_method_type, :name => 'phone')
    @contact_method_type_sms = Factory(:contact_method_type, :name => 'sms')
    @attrs = {:contact_method_type_id => @contact_method_type_phone.id, :delivery_route => '19076990602'}
  end

  it "should create a contact_method given correct attributes" do
    @recipient.contact_methods.create!(@attrs)
  end

  describe "validations" do
    it "should require a contact_method_type_id" do
      bad_contact_method = @recipient.contact_methods.build(@attrs.merge(:contact_method_type_id => '   '))
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
      good_contact_method = @recipient.contact_methods.build(@attrs.merge(:contact_method_type_id => @contact_method_type_sms.id))
      good_contact_method.should be_valid
    end
  end
end
