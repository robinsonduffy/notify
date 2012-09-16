require 'spec_helper'

describe Recipient do
  before(:each) do
    @attrs = {:external_id => "123456", :recipient_type => 'student', :first_name => 'First', :last_name => 'Last'}
  end

  it "should create a recipient if all the right attributes are provided" do
    Recipient.create!(@attrs)
  end

  describe "validations" do
    it "should require an external_id" do
      bad_recipient = Recipient.new(@attrs.merge(:external_id => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a recipient_type" do
      bad_recipient = Recipient.new(@attrs.merge(:recipient_type => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a first_name" do
      bad_recipient = Recipient.new(@attrs.merge(:first_name => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a last_name" do
      bad_recipient = Recipient.new(@attrs.merge(:last_name => '    '))
      bad_recipient.should_not be_valid
    end

    it "should require a unique external_id/recipient_type combo" do
      Recipient.create!(@attrs)
      bad_recipient = Recipient.new(@attrs)
      bad_recipient.should_not be_valid
    end

    it "should allow the same external_id for different recipient_types" do
      Recipient.create!(@attrs)
      good_recipient = Recipient.new(@attrs.merge(:recipient_type => 'staff'))
      good_recipient.should be_valid
    end

  end

end
